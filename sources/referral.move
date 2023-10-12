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
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    
    friend townesquare::user;
    // -------
    // Structs
    // -------
    struct Referral has key {
        code: String,  // typed by user or in the off-chain level
        referrer: Option<address>,  // the user who referred the new user
        is_active: bool
    }

    // ----------------
    // Public functions
    // ----------------
    public fun init(signer_ref: &signer, code: String, referrer: Option<address>) {
        move_to(
            signer_ref,
            Referral {
                code: code,
                referrer: option::none(),   // TODO: must be conditionally set
                is_active: false
            }
        )
    }

    // Activate a referral
    public(friend) fun activate(signer_ref: &signer, referral: &Referral) acquires Referral {
        let referral_resource = authorized_borrow_mut(signer_ref);
        // change referral status to active
        referral_resource.is_active = true;
    }

    // Deactivate a referral 

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

    // get referral status
    public fun is_active(referral: &Referral): bool {
        referral.is_active
    }
}

