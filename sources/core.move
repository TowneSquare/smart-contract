/*
    master module

    TODO:
        - description
        - add friends mechanism
        - add blacklist mechanism from transaction contract
        - implements an emergency mechanism

*/

module townesquare::core {
    use aptos_std::smart_vector::{Self, SmartVector};
    use aptos_std::type_info;
    use std::error;
    use std::signer;
    use std::string::{String};
    use std::vector;


    // Global storage for data that needs checks with every new entry.
    // Only TS can initiate and write to this storage.
    struct Data has key {
        referral_codes: SmartVector<String>,
        // TODO: add usernames
    }

    // TODO init by ts addr; that's a one time use function
    // store structs under ts addr
    // TODO: init all structs and feature modules here
    fun init_module(signer_ref: &signer) {
        if (signer::address_of(signer_ref) == @townesquare) {
            // init Data resource and move it to TS
            move_to(
                signer_ref,
                Data {
                    referral_codes: smart_vector::new<String>(),
                }
            )
        }
        
    }

    // Add new referral code to the list; callable only by TS
    public(friend) fun add_referral_code(){}

    // ---------
    // Accessors
    // ---------

    // Borrow the referral code list;
    inline fun authorized_borrow_mut(): &mut Data {
        borrow_global_mut<Data>(@townesquare)
    }

    // TODO: get referral list

}