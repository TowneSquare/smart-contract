/*
    This defines the referral module for TowneSquare.
    The referral is used to track scores for users who refer others to the platform.
    When a new address signs up for TowneSquare, a referral resource will be created
    with the field address_is_active set to false. To set it to true, the address have to make
    a social transaction.  

    | Referral Tier | Referral Points | Referral Range |
    |---------------|-----------------|----------------|
    | Tier 1        | 100             | 0-24           |
    | Tier 2        | 110 (10% bonus) | 25-49          |
    | Tier 3        | 115 (15% bonus) | 50-74          |
    | Tier 4        | 120 (20% bonus) | 75-119         |
    | Tier 5        | 125 (25% bonus) | 120-199        |
    | Tier 6        | 135 (35% bonus) | 200+           |

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
        referrer: Option<address>,
        tier_level: u64    // = Tier.level  
    }

    // Activity status
    struct Active has key {}
    struct Inactive has key {}

    // Referral tiers; There are 6 tiers for now
    struct Tier has key {
        level: u64, // n
        points: u64,
        // minimum number of referrals to reach this tier.
        // max_referrals<Tier n+1> = min_referrals<Tier n> - 1
        min_referrals: u64, 
        // maximum number of referrals of this tier.
        // min_referrals<Tier n+1> = max_referrals<Tier n> + 1
        max_referrals: u64,  
        // current number of referrals; incremented when a new user signs up with the referral code AND becomes active.
        current_active_referrals: u64, 
        // current number of referrals; incremented when a new user signs up with the referral code BUT not yet active.
        current_inactive_referrals: u64,   
    }

    // -------
    // Asserts
    // -------

    // TODO: assert referral.tier_level = tier.level and between 1 and 6

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
                referrer: option::none(),   // TODO: must be conditionally set
                tier_level: 1
            }
        );
        // move tier resource to the signer
        // level 1 inline fun

        // Based on activity type, set the activity status
        if (type_info::type_of<Activity>() == type_info::type_of<Active>()) {
            move_to(signer_ref, Active {})
        } else if (type_info::type_of<Activity>() == type_info::type_of<Inactive>()) {
            move_to(signer_ref, Inactive {})
        }
    }

    // Chance user's activity status for X to Y
    inline fun change_activity_status<Tier, X, Y>(signer_ref: &signer) acquires Referral {
        assert!(type_info::type_of<X>() != type_info::type_of<Y>(), 1);
        let referral = borrow_global<Referral>(signer::address_of(signer_ref));
        // from Inactive to Active
        if (
            type_info::type_of<X>() == type_info::type_of<Inactive>() 
            && type_info::type_of<Y>() == type_info::type_of<Active>()
        ) {  
            // TODO: assert atleast one transaction has been made from the signer's address
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

    // TODO: Tiers; UPDATE ALSO REFERRAL RESOURCE

    // Tier 1

    // Tier 2

    // Tier 3

    // Tier 4

    // Tier 5

    // Tier 6

    // level up

    // level down

    // ---------
    // Accessors
    // ---------

    // Referral

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

    // get referral code
    public fun referral(referral: &Referral): String {
        referral.code
    }

    // get referrer address
    public fun referrer(referral: &Referral): address {
        *option::borrow<address>(&referral.referrer)
    }

    // Activity Status

    // Checks if user is an active
    public fun address_is_active(user_addr: address): bool {
        exists<Active>(user_addr)
    }

    // Checks if user is inactive
    public fun address_is_inactive(user_addr: address): bool {
        exists<Inactive>(user_addr)
    }

    // Tiers

    // TODO: is level one

    // TODO: is level two

    // TODO: is level three

    // TODO: is level four

    // TODO: is level five

    // TODO: is level six

    // --------------
    // View functions
    // --------------

    // referral

    #[view]
    public fun get_referral_code(signer_ref: &signer): String acquires Referral {
        let referral = authorized_borrow(signer_ref);
        referral.code
    }

    #[view]
    public fun get_referrer_address(signer_ref: &signer): address acquires Referral {
        let referral = authorized_borrow(signer_ref);
        *option::borrow<address>(&referral.referrer)
    }

    // activity

    #[view]
    public fun signer_is_active(signer_ref: &signer): bool {
        address_is_active(signer::address_of(signer_ref))
    }

    #[view]
    public fun signer_is_inactive(signer_ref: &signer): bool {
        address_is_inactive(signer::address_of(signer_ref))
    }

    // tier
    
    // TODO: tier resource
    // TODO: tier level
    // TODO: tier points
    // TODO: tier min_referrals
    // TODO: tier max_referrals
    // TODO: tier current_active_referrals
    // TODO: tier current_inactive_referrals
    // TODO: how many points to level up; max_referrals - current_active_referrals + 1
    // TODO: how many points to level down; current_active_referrals - min_referrals + 1

}

