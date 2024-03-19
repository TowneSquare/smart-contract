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
*/
module townesquare::referral {

    use aptos_framework::event;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    
    friend townesquare::core;

    // -------
    // Structs
    // -------

    /// Referral resource
    struct Referral has key {
        code: String,  // typed by user or in the off-chain level
        referrer: Option<address>
    }

    // ------
    // Events
    // ------

    #[event]
    struct ReferralCreated has drop, store {
        code: String,
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

    /// initialize function
    public(friend) fun create_referral(signer_ref: &signer, code: String, referrer: Option<address>) {
        move_to(signer_ref, Referral { code, referrer } );
        event::emit(
            ReferralCreated {
                code,
                referrer
            }
        );
    }
    
    /// Remove referral
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

    /// get referral code
    public fun referral(referral: &Referral): String {
        referral.code
    }

    /// get referrer address
    public fun referrer(referral: &Referral): address {
        assert!(!option::is_none<address>(&referral.referrer), 1);
        *option::borrow<address>(&referral.referrer)
    }

    // --------------
    // View functions
    // --------------

    #[view]
    /// Get the referral code of the signer
    public fun get_referral_code(signer_ref: &signer): String acquires Referral {
        let referral = borrow_global<Referral>(signer::address_of(signer_ref));
        referral.code
    }

    #[view]
    /// Get the referrer address of the signer
    public fun get_referrer_address(signer_ref: &signer): address acquires Referral {
        let referral = borrow_global<Referral>(signer::address_of(signer_ref));
        *option::borrow<address>(&referral.referrer)
    }

    #[view]
    /// Returns true if the signer has a referrer and the referrer address
    public fun has_referrer(signer_ref: &signer): (bool, address) acquires Referral {
        let referral = borrow_global<Referral>(signer::address_of(signer_ref));
        if (!option::is_none<address>(&referral.referrer)) {
            (true, *option::borrow<address>(&referral.referrer))
        } else { (false, @0x0) }
    }

    #[test_only]
    friend townesquare::user;

}

