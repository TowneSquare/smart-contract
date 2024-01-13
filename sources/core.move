/*
    core module; this will be the entry point for all other modules
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

    // Global storage for data that needs checks with every new entry.
    // Only TS can initiate and write to this storage.
    struct Data has key {
        referral_codes: SmartVector<String>,
        usernames: SmartVector<String>,
        // Used to manage data resource fields and fire events
        signer_cap: SignerCapability
    }

    // -------------------
    // Initialize Function
    // -------------------

    public entry fun init(signer_ref: &signer) {
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
    
    // Creation

    // Create a new user
    public entry fun create_user<Type>(
        signer_ref: &signer,
        pfp: address,
        referral_code: String,
        referrer: Option<address>,
        username: String
    ) acquires State, Data {
        assert!(
            type_info::type_of<Type>() == type_info::type_of<Personal>()
            || type_info::type_of<Type>() == type_info::type_of<Creator>()
            || type_info::type_of<Type>() == type_info::type_of<Moderator>(),
            1
        );
        let signer_addr = signer::address_of(signer_ref);
        // create user based on type
        if (type_info::type_of<Type>() == type_info::type_of<Personal>()) {
            user::create_user_internal<Personal>(signer_ref, pfp, username);
            // create referral and add it to the data resource
            referral::create_referral(signer_ref, referral_code, referrer);
            add_referral_code(signer_addr, referral_code);
            // add username to the data resource
            add_username(signer_addr, username);
            // init post resource
            post::init(signer_ref);
            // TODO: add event
        } else if (type_info::type_of<Type>() == type_info::type_of<Creator>()) {
            user::create_user_internal<Creator>(signer_ref, pfp, username);
            // create referral and add it to vector
            referral::create_referral(signer_ref, referral_code, referrer);
            add_referral_code(signer_addr, referral_code);
            // add username to the data resource
            add_username(signer_addr, username);
            // init post resource
            post::init(signer_ref);
            // TODO: add event
        } else {
            user::create_user_internal<Moderator>(signer_ref, pfp, username);
            // create referral and add it to vector
            referral::create_referral(signer_ref, referral_code, referrer);
            add_referral_code(signer_addr, referral_code);
            // add username to the data resource
            add_username(signer_addr, username);
            // init post resource
            post::init(signer_ref);
            // TODO: add event
        };
    }

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

    // Create a post
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

    // Delete a user given a type
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

    // Delete a user; all types
    public entry fun delete_user(
        signer_ref: &signer
    ) acquires State, Data {
        let user_addr = signer::address_of(signer_ref);
        user::delete_user_internal(signer_ref);
        referral::remove_referral(signer_ref);
        // data resource related
        remove_referral(user_addr, referral::get_referral_code(signer_ref, user_addr));
        remove_username(user_addr, user::get_personal_username(user_addr));
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

    // Update

    // User related
    public entry fun set_username<Type>(
        signer_ref: &signer,
        new_username: String
    ) {
        // based on type
        if (type_info::type_of<Type>() == type_info::type_of<Personal>()) {
            user::set_username_internal<Personal>(signer_ref, new_username);
            // TODO: event
        } else if (type_info::type_of<Type>() == type_info::type_of<Creator>()) {
            user::set_username_internal<Creator>(signer_ref, new_username);
            // TODO: event
        }
        else if (type_info::type_of<Type>() == type_info::type_of<Moderator>()) {
            user::set_username_internal<Moderator>(signer_ref, new_username);
            // TODO: event
        } else { assert!(false, 1) };
    }

    public entry fun change_pfp<Type>(
        signer_ref: &signer,
        new_pfp: address
    ) {
        // based on type
        if (type_info::type_of<Type>() == type_info::type_of<Personal>()) {
            user::set_pfp_internal<Personal>(signer_ref, new_pfp);
            // TODO: event
        } else if (type_info::type_of<Type>() == type_info::type_of<Creator>()) {
            user::set_pfp_internal<Creator>(signer_ref, new_pfp);
            // TODO: event
        } else if (type_info::type_of<Type>() == type_info::type_of<Moderator>()) {
            user::set_pfp_internal<Moderator>(signer_ref, new_pfp);
            // TODO: event
        } else { assert!(false, 1) };
    }

    public entry fun change_from_personal_to_creator(signer_ref: &signer) {
        user::change_user_type<Personal, Creator>(signer_ref);
        // TODO: event
    }

    public entry fun change_from_creator_to_personal(signer_ref: &signer) {
        user::change_user_type<Creator, Personal>(signer_ref);
    }

    // TODO: moderator is added done manually for now

    // TODO: change post visibility; not needed for now as we're only using public posts

    // ---------
    // Accessors
    // ---------

    // Borrow state resource
    inline fun authorized_state_borrow(addr: address): &State acquires State, Data {
        borrow_global<State>(@townesquare)
    }

    // Borrow data resource; needed to read data
    inline fun authorized_data_borrow(addr: address): &Data acquires State, Data {
        // note: no need to assert again.
        borrow_global<Data>(authorized_state_borrow(addr).core)
    }

    // Borrow mutable data resource; needed to update data
    inline fun authorized_data_borrow_mut(addr: address): &mut Data acquires State, Data {
        borrow_global_mut<Data>(authorized_state_borrow(addr).core)
    }

    // add new referral code to the data resource
    inline fun add_referral_code(
        addr: address, 
        referral_code: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        smart_vector::contains<String>(
            &authorized_data_borrow(authorized_state_borrow(addr).core).referral_codes, 
            &referral_code
            );
        // add the new code to the vector
        smart_vector::push_back<String>(
            &mut authorized_data_borrow_mut(authorized_state_borrow(addr).core).referral_codes, 
            referral_code
        );
    }

    // add username to the data resource
    inline fun add_username(
        addr: address, 
        username: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        smart_vector::contains<String>(
            &authorized_data_borrow(authorized_state_borrow(addr).core).usernames, 
            &username
            );

        // add the new code to the vector
        smart_vector::push_back<String>(
            &mut authorized_data_borrow_mut(authorized_state_borrow(addr).core).usernames, 
            username
        );
    }

    // remove referral from data
    inline fun remove_referral(
        addr: address, 
        referral_code: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        let (valid, index) = smart_vector::index_of<String>(
            &authorized_data_borrow(authorized_state_borrow(addr).core).referral_codes, 
            &referral_code
        );
        assert!(valid == true, 1);
        // remove the code from the vector
        smart_vector::remove<String>(
            &mut authorized_data_borrow_mut(authorized_state_borrow(addr).core).referral_codes, 
            index
            );
    }

    // remove username from data
    inline fun remove_username(
        addr: address, 
        username: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        let (valid, index) = smart_vector::index_of<String>(
            &authorized_data_borrow(authorized_state_borrow(addr).core).usernames, 
            &username
        );
        assert!(valid == true, 1);
        // remove the code from the vector
        smart_vector::remove<String>(
            &mut authorized_data_borrow_mut(authorized_state_borrow(addr).core).usernames, 
            index
            );
    }

    // TODO: get referral list; can be gas heavy

    #[test_only]
    use std::option;
    use std::string::{Self};
    use std::vector;
    use aptos_framework::timestamp;
    use std::features;

    #[test_only]
    const USERNAME: vector<u8> = b"username";
    const REFERRAL_CODE: vector<u8> = b"referral_code";

    #[test(townesquare = @townesquare)]
    public fun init_test(
        townesquare: &signer
    ) {
        init(townesquare);
    }

    #[test(aptos_framework = @0x1, alice = @0x123, townesquare = @townesquare, pfp = @345)]
    fun test(
        aptos_framework: &signer,
        alice: &signer,
        townesquare: &signer,
        pfp: address
    ) acquires Data, State {
        features::change_feature_flags(aptos_framework, vector[23, 26], vector[]);
        timestamp::set_time_has_started_for_testing(aptos_framework);
        init(townesquare);
        create_user<Personal>(
            alice,
            pfp,
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