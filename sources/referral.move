/*
    This defines the referral module for TowneSquare.
    The referral is used to track scores for users who refer others to the platform.
    When a new address signs up for TowneSquare, a referral resource will be created
    with the field is_active set to false. To set it to true, the address have to make
    a social transaction.  

    TODO: 
        - implement the referrer logic 
        - get referrer address must be conditional since not all users have referrers
*/
module townesquare::referral {
    use aptos_std::smart_vector::{Self, SmartVector};
    use aptos_std::type_info;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    use townesquare::core;
    
    // -------
    // Structs
    // -------
    struct Referral has key {
        code: String,  // typed by user or in the off-chain level
        referrer: Option<address>
    }

    // Activity status
    struct Active has key {}
    struct Inactive has key {}

    // ----------------
    // Public functions
    // ----------------
    public fun init<Activity>(signer_ref: &signer, code: String, referrer: Option<address>) {
        // add the referral code to the global list; useful to check the code's validity.
        core::add_referral_code(signer::address_of(signer_ref), code);
        // move the referral resource to the signer
        move_to(
            signer_ref,
            Referral {
                code: code,
                referrer: option::none()   // TODO: must be conditionally set
            }
        );
        // Based on activity type, set the activity status
        if (type_info::type_of<Activity>() == type_info::type_of<Active>()) {
            move_to(signer_ref, Active {})
        } else if (type_info::type_of<Activity>() == type_info::type_of<Inactive>()) {
            move_to(signer_ref, Inactive {})
        }
    }

    // Chance user's activity status for X to Y
    public fun change_activity_status<X, Y>(signer_ref: &signer) acquires Referral {
        assert!(type_info::type_of<X>() != type_info::type_of<Y>(), 1);
        let referral = borrow_global<Referral>(signer::address_of(signer_ref));
        // from Inactive to Active
        if (
            type_info::type_of<X>() == type_info::type_of<Inactive>() 
            && type_info::type_of<Y>() == type_info::type_of<Active>()
        ) {  
            move referral;
            move_to(signer_ref, Active {});
        // from Active to Inactive
        } else if (
            type_info::type_of<X>() == type_info::type_of<Active>() 
            && type_info::type_of<Y>() == type_info::type_of<Inactive>()
        ) {
            move referral;
            move_to(signer_ref, Inactive {});
        } else { assert!(false, 2); }
    }

    // ---------
    // Accessors
    // ---------

    // get referral resource
    inline fun authorized_borrow(signer_ref: &signer): &Referral {
        let signer_addr = signer::address_of(signer_ref);
        assert!(exists<Referral>(signer_addr), 1);
        borrow_global<Referral>(signer_addr)
    }
    
    // get mut referral resource
    inline fun authorized_borrow_mut(signer_ref: &signer): &mut Referral acquires Referral {
        let signer_addr = signer::address_of(signer_ref);
        assert!(exists<Referral>(signer_addr), 1);
        borrow_global_mut<Referral>(signer_addr)
    }

    // --------------
    // View functions
    // --------------

    // get referral code
    public fun referral(referral: &Referral): String {
        referral.code
    }

    // TODO: get referrer address
    public fun referrer(referral: &Referral): address {
        *option::borrow<address>(&referral.referrer)
    }

    // Checks if user is an active
    public fun is_active(user_addr: address): bool {
        exists<Active>(user_addr)
    }

    // Checks if user is inactive
    public fun is_inactive(user_addr: address): bool {
        exists<Inactive>(user_addr)
    }
}

