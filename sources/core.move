/*
    core module; this will be the entry point for all other modules

    TODO: 
    - functions visibilty should be private: remove public tag
    - needs a revisit
*/

module townesquare::core {
    use aptos_framework::account::{Self, SignerCapability};
    use aptos_std::smart_vector::{Self, SmartVector};
    use aptos_std::type_info;
    use std::error;
    use std::option::{Option};
    use std::signer;
    use std::string::{String};
    use townesquare::post::{Self, Public};
    use townesquare::referral;
    use townesquare::user::{Self, Personal, Creator, Moderator};

    // ---------
    // Constants
    // ---------

    const TS_DATA_SEED: vector<u8> = b"TownesquareDataSeed";

    // -------
    // Structs
    // -------

    struct State has key {
        core: address
    }

    /// Global storage for data that needs checks with every new entry.
    /// Only TS can initiate and write to this storage.
    struct Data has key {
        referral_codes: SmartVector<String>,
        usernames: SmartVector<String>,
        // Used to manage data resource fields and fire events
        signer_cap: SignerCapability
    }

    // -------------------
    // Initialize Function
    // -------------------

    fun init_module(signer_ref: &signer) {
        assert!(signer::address_of(signer_ref) == @townesquare, error::permission_denied(1));
        // Create a resource account and store signing capabilities
        let (resource_acc_signer, signer_cap) = account::create_resource_account(signer_ref, TS_DATA_SEED);
        move_to(signer_ref, State { core: signer::address_of(&resource_acc_signer) });
        // init Data resource and move it to state account
        move_to(
            &resource_acc_signer,
            Data {
                referral_codes: smart_vector::new<String>(),
                usernames: smart_vector::new<String>(),
                signer_cap: signer_cap
            }
        );
        // init post
        post::init(signer_ref);
    }

    // ---------------
    // Entry Functions
    // ---------------
    
    /// Create a new user; personal by default
    public entry fun create_user(
        signer_ref: &signer,
        referral_code: String,
        referrer: Option<address>,
        username: String
    ) acquires State, Data {
        user::create_user_internal<Personal>(signer_ref, username);
        // create referral and add it to vector
        referral::create_referral(signer_ref, referral_code, referrer);
        add_referral_code(referral_code);
        // add username to the data resource
        add_username(username);
        // init post resource
        post::init(signer_ref);
    }

    /// Add a user type
    public entry fun add_user_type<Type>(
        signer_ref: &signer
    ) {
        // based on type
        if (type_info::type_of<Type>() == type_info::type_of<Personal>()) {
            user::add_user_type_internal<Personal>(signer_ref);
        } else if (type_info::type_of<Type>() == type_info::type_of<Creator>()) {
            user::add_user_type_internal<Creator>(signer_ref);
        } else { assert!(false, 1) }

        // TODO: moderator is added done manually for now
    }

    /// Create a post
    public entry fun create_post<Visibility>(
        signer_ref: &signer,
        content: vector<u8>
    ){
        user::assert_user_exists(signer::address_of(signer_ref));
        // only public post for now
        post::create_post_internal<Public>(
            signer_ref, 
            content
            );

        // TODO: add event
    }

    // Deletion

    /// Delete a user given a type
    public entry fun delete_user_type<Type>(
        signer_ref: &signer
    ) {
        // based on type
        if (type_info::type_of<Type>() == type_info::type_of<Personal>()) {
            user::delete_user_type_internal<Personal>(signer_ref);
            // TODO: event
        } else if (type_info::type_of<Type>() == type_info::type_of<Creator>()) {
            user::delete_user_type_internal<Creator>(signer_ref);
            // TODO: event
        } else if (type_info::type_of<Type>() == type_info::type_of<Moderator>()) {
            user::delete_user_type_internal<Moderator>(signer_ref);
            // TODO: event
        } else { assert!(false, 1) };
        referral::remove_referral(signer_ref);
    }

    /// Delete a user; all types
    public entry fun delete_user(
        signer_ref: &signer
    ) acquires State, Data {
        let user_addr = signer::address_of(signer_ref);
        user::delete_user_internal(signer_ref);
        referral::remove_referral(signer_ref);
        // data resource related
        remove_referral(referral::get_referral_code(signer_ref));
        remove_username(user::get_username_from_address(user_addr));
        // TODO: add events
    }

    // Delete a post
    // public entry fun delete_post<T: key>(
    //     signer_ref: &signer,
    //     post_address: address
    // ) {
    //     user::assert_user_exists(signer::address_of(signer_ref));
    //     // only public post for now
    //     post::delete_post_internal<T>(signer_ref, object::address_to_object<T>(post_address));
    //     // TODO: add events 
    // }

    // TODO: force delete post; callable only by moderators

    /// Change user type from personal to creator
    public entry fun change_from_personal_to_creator(signer_ref: &signer) {
        user::change_user_type<Personal, Creator>(signer_ref);
        // TODO: event
    }

    /// Change user type from creator to personal
    public entry fun change_from_creator_to_personal(signer_ref: &signer) {
        user::change_user_type<Creator, Personal>(signer_ref);
    }

    // TODO: moderator is added done manually for now

    // TODO: change post visibility; not needed for now as we're only using public posts

    // ---------
    // Accessors
    // ---------

    /// Helper function to borrow state resource
    inline fun get_state(): &State acquires State, Data {
        borrow_global<State>(@townesquare)
    }

    // Helper function to add new referral code to the data resource
    inline fun add_referral_code(
        referral_code: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        smart_vector::contains<String>(
            &borrow_global<Data>(get_state().core).referral_codes, 
            &referral_code
            );
        // add the new code to the vector
        smart_vector::push_back<String>(
            &mut borrow_global_mut<Data>(get_state().core).referral_codes, 
            referral_code
        );
    }

    /// Helper function to add username to the data resource
    inline fun add_username(
        username: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        smart_vector::contains<String>(
            &borrow_global<Data>(get_state().core).usernames, 
            &username
            );

        // add the new code to the vector
        smart_vector::push_back<String>(
            &mut borrow_global_mut<Data>(get_state().core).usernames, 
            username
        );
    }

    /// Helper function to remove referral from data
    inline fun remove_referral(
        referral_code: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        let (valid, index) = smart_vector::index_of<String>(
            &borrow_global<Data>(get_state().core).referral_codes, 
            &referral_code
        );
        assert!(valid == true, 1);
        // remove the code from the vector
        smart_vector::remove<String>(
            &mut borrow_global_mut<Data>(get_state().core).referral_codes, 
            index
            );
    }

    // Helper function to remove username from data
    inline fun remove_username(
        username: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        let (valid, index) = smart_vector::index_of<String>(
            &borrow_global<Data>(get_state().core).usernames, 
            &username
        );
        assert!(valid == true, 1);
        // remove the code from the vector
        smart_vector::remove<String>(
            &mut borrow_global_mut<Data>(get_state().core).usernames, 
            index
            );
    }

    #[test_only]
    use std::option;
    #[test_only]
    use std::string::{Self};
    #[test_only]
    use std::features;

    #[test_only]
    const USERNAME: vector<u8> = b"username";
    #[test_only]
    const REFERRAL_CODE: vector<u8> = b"referral_code";

    #[test(townesquare = @townesquare)]
    public fun init_test(
        townesquare: &signer
    ) {
        init_module(townesquare);
    }

    #[test(aptos_framework = @0x1, alice = @0x123, townesquare = @townesquare, pfp = @345)]
    fun test(
        aptos_framework: &signer,
        alice: &signer,
        townesquare: &signer,
    ) acquires Data, State {
        features::change_feature_flags(aptos_framework, vector[23, 26], vector[]);
        init_module(townesquare);
        create_user(
            alice,
            string::utf8(REFERRAL_CODE),
            option::none(), // no referrer
            string::utf8(USERNAME)
        );
        create_post<Public>(
            alice,
            b"content"
        );
    }
}