/*
    core module

    TODO:
        - description
        - add friends mechanism
        - add blacklist mechanism from transaction contract
        - implement an emergency mechanism
        - make borrow functions names clearer
        - organise functions per type
        - remove referral function

*/

module townesquare::core {
    use aptos_framework::account::{Self, SignerCapability};
    use aptos_std::smart_vector::{Self, SmartVector};
    use aptos_std::type_info;
    use std::error;
    use std::signer;
    use std::string::{String};
    use std::vector;
    use townesquare::user;

    friend townesquare::referral;

    // ---------
    // Constants
    // ---------

    const DATA_SEED: vector<u8> = b"Data";

    // -------
    // Structs
    // -------

    // managing the system state
    struct State has key {
        core: address
    }

    // Global storage for data that needs checks with every new entry.
    // Only TS can initiate and write to this storage.
    struct Data has key {
        referral_codes: SmartVector<String>,
        // TODO: add usernames
        // Used to manage data resource fields
        signer_cap: SignerCapability
    }

    // TODO init by ts addr; that's a one time use function
    // store structs under ts addr
    // TODO: init all structs and feature modules here
    fun init_module(signer_ref: &signer) {
        if (signer::address_of(signer_ref) == @townesquare) {
            // Create a resource account and store signing capabilities
            let (resource_acc_signer, signer_cap) = account::create_resource_account(signer_ref, DATA_SEED);
            // store the resource acc address in state
            move_to(
                signer_ref,
                State {
                    core: signer::address_of(&resource_acc_signer)
                }
            );
            // init Data resource and move it to state acc
            move_to(
                &resource_acc_signer,
                Data {
                    referral_codes: smart_vector::new<String>(),
                    signer_cap
                }
            )
        }
        
    }

    // ---------
    // Accessors
    // ---------

    // Borrow state resource
    inline fun authorized_borrow_state(addr: address): &State acquires State, Data {
        // assert addr is a ts user
        user::assert_user_exists(addr);
        borrow_global<State>(@townesquare)
    }

    // Borrow data resource; needed to read data
    inline fun authorized_data_borrow(addr: address): &Data {
        // note: no need to assert again.
        let state = authorized_borrow_state(addr);
        borrow_global<Data>(state.core)
    }

    // Borrow mutable data resource; needed to update data
    inline fun authorized_data_borrow_mut(addr: address): &mut Data acquires State, Data {
        // note: no need to assert again.
        let state = authorized_borrow_state(addr);
        borrow_global_mut<Data>(state.core)
    }

    // Borrow referral codes vector; needed to insure referral codes uniqueness
    inline fun authorized_borrow_referral_codes_vector(addr: address): &SmartVector<String> {
        let data = authorized_data_borrow(addr);
        &data.referral_codes
    }

    // Borrow mutable referral codes vector; needed to insert/remove referral codes
    inline fun authorized_borrow_mut_referral_codes_vector_ref(addr: address): &mut SmartVector<String> acquires Data {
        let data = authorized_data_borrow_mut(addr);
        &mut data.referral_codes
    }

    // Referral code exists; needed when creating a new referral resource.
    // TODO: is this still needed?
    // referal code existence verification can be done inside the creation function.
    public(friend) fun referral_code_exists(
        addr: address, 
        referral_code: String
    ): bool acquires State, Data {
        // borrow referral vector from data resource
        let referral_codes_vector = authorized_borrow_referral_codes_vector(addr);
        // iterate through the vector and return true if the code exists, and false otherwise
        smart_vector::contains<String>(referral_codes_vector, &referral_code)
    }

    // add new referral code to the list
    public(friend) fun add_referral_code(
        addr: address, 
        referral_code: String
    ) acquires State, Data {
        // iterate through the vector and return true if the code exists, and false otherwise
        smart_vector::contains<String>(
            authorized_borrow_referral_codes_vector(addr), 
            &referral_code
            );
        // borrow referral vector from data resource
        let referral_codes_vector = authorized_borrow_mut_referral_codes_vector_ref(addr);
        // add the new code to the vector
        smart_vector::push_back<String>(referral_codes_vector, referral_code);
    }

    // TODO: remove referral

    // TODO: get referral list; can be gas heavy

}