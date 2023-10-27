/*
    This defines the referral module for TowneSquare.
    The referral is used to track scores for users who refer others to the platform.
    When a new address signs up for TowneSquare, a referral resource will be created
    with the field address_is_active set to false. To set it to true, the address have to make
    a social transaction.  

    Referral tiers are set/calculated off-chain:

    | Referral Tier | Referral Points | Referral Range |
    |---------------|-----------------|----------------|
    | Tier 1        | 100             | 0-24           |
    | Tier 2        | 110 (10% bonus) | 25-49          |
    | Tier 3        | 115 (15% bonus) | 50-74          |
    | Tier 4        | 120 (20% bonus) | 75-119         |
    | Tier 5        | 125 (25% bonus) | 120-199        |
    | Tier 6        | 135 (35% bonus) | 200-201+       |

    TODO: 
        - implement the referrer logic 
        - get referrer address must be conditional since not all users have referrers
        - set funcs visibity
*/
module townesquare::referral {
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    
    friend townesquare::core;

    // -------
    // Structs
    // -------

    // Referral resource
    struct Referral has key {
        code: String,  // typed by user or in the off-chain level
        referrer: Option<address>
    }

    // // Referral tiers; There are 6 tiers for now
    // struct Tier has key {
    //     level: u64, // n
    //     bonus_rate: u64,
    //     // minimum number of referrals to reach this tier.
    //     // max_referrals<tier.level n+1> = min_referrals<tier.level n> - 1
    //     min_referrals: u64, 
    //     // maximum number of referrals of this tier.
    //     // min_referrals<tier.level n+1> = max_referrals<tier.level n> + 1
    //     max_referrals: u64 
    // }

    // -------
    // Asserts
    // -------

    // TODO: users cannot be active and inactive at the same time => Toggle model
    // TODO: assert referral.tier_level = tier.level And is in R : [1, 6]
    // TODO: (copilot suggestion) assert referral.code exists in global list of referral codes
    // TODO: assert tier.min_referrals is in R : {0, 25, 50, 75, 120, 200}
    // TODO: assert tier.max_referrals is in R : {24, 49, 74, 119, 199, 201}

    // ----------------
    // Public functions
    // ----------------

    // initialize function; used in (user/core?), initialize the referral resource when 
    // a user signs up for the platform. All users start as inactive, and with a referral code.
    public(friend) fun create_referral(signer_ref: &signer, code: String, referrer: Option<address>) {
        // add the referral code to the global list; useful to check the code's validity.
        // referrer typed
        if (!option::is_none<address>(&mut referrer)) {
            // assert referrer is a user
            // TODO user::assert_user_exists(option::extract<address>(referrer));
            // move referral resource to the signer
            move_to(
                signer_ref,
                Referral {
                    code: code,
                    referrer: referrer,
                }
            );
        } else {
            // move the referral resource to the signer
            move_to(
                signer_ref,
                Referral {
                    code: code,
                    referrer: option::none()
                }
            );
            // move tier resource to the signer
        };
    }
    
    // Remove referral
    public(friend) fun remove_referral(signer_ref: &signer) acquires Referral {
        let user_addr = signer::address_of(signer_ref);
        // assert referral exists under signer address
        assert!(exists<Referral>(user_addr), 1);
        // remove the referral resource
        Referral {code: _, referrer: _} = move_from<Referral>(user_addr);
    }

    // TODO: a function to to change referral from inactive and active using change_activity_status.
    // TODO: this function will be called only when a user makes a social transaction.

    

    // level up
    // if tier_n.current_active_referrals = tier_n+1.min_referrals THEN level up
    /* 
        Tier n+1: 
            tier_n+1.min_referrals = tier_n.max_referrals + 1
            tier_n+1.max_referrals = tier_n+2.min_referrals - 1
                > IF tier_n+2 does not exist, tier_n+1.max_referrals = u64::max_value 
    */

    // level down
    // if tier_n.current_active_referrals = tier_n-1.max_referrals THEN level down
    /*
        Tier n-1:
            tier_n-1.min_referrals = tier_n-2.max_referrals + 1
                > IF tier_n-2 does not exist, tier_n-1.min_referrals = 0
            tier_n-1.max_referrals = tier_n.min_referrals - 1
    */

    // ---------
    // Accessors
    // ---------

    // Referral

    // get referral resource
    inline fun authorized_borrow(signer_ref: &signer, user_addr: address): &Referral {
        let signer_addr = signer::address_of(signer_ref);
        // assert signer and user exist
        assert!(exists<Referral>(signer_addr), 1);
        assert!(exists<Referral>(user_addr), 1);
        borrow_global<Referral>(user_addr)
    }
    
    // get mut referral resource
    inline fun authorized_borrow_mut(signer_ref: &signer, user_addr: address): &mut Referral acquires Referral {
        let signer_addr = signer::address_of(signer_ref);
        // assert signer and user exist
        assert!(exists<Referral>(signer_addr), 1);
        borrow_global_mut<Referral>(signer_addr)
    }

    // get referral code
    public fun referral(referral: &Referral): String {
        referral.code
    }

    // get referrer address
    public fun referrer(referral: &Referral): address {
        assert!(!option::is_none<address>(&referral.referrer), 1);
        *option::borrow<address>(&referral.referrer)
    }

    // --------------
    // View functions
    // --------------

    // referral

    #[view]
    public fun get_referral_code(signer_ref: &signer, user_addr: address): String acquires Referral {
        let referral = authorized_borrow(signer_ref, user_addr);
        referral.code
    }

    #[view]
    public fun get_referrer_address(signer_ref: &signer, user_addr: address): address acquires Referral {
        let referral = authorized_borrow(signer_ref, user_addr);
        *option::borrow<address>(&referral.referrer)
    }

    #[view]
    public fun has_referrer(signer_ref: &signer, user_addr: address): (bool, address) acquires Referral {
        let referral = authorized_borrow(signer_ref, user_addr);
        if (option::is_none<address>(&referral.referrer) == false)
        return (true, *option::borrow<address>(&referral.referrer));
        (false, @0x0)
    }

}

