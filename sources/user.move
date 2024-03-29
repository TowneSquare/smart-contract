/*
    Module for user
    - user types: personal, creator, moderator

    TODO:
        - add caps so that user can't self-promote to moderator
        - add big table for posts; would be useful in case off chain data is lost
        or in maintenance, in that case, we can get table of posts, it can be costy tho.
        - authorized borrow to moderators and list of connected users
        - organise functions
        - not all of the current funcs that are tagged with #[view] are actually views, fix it
        - create_user_internal should be optimised

        - add referral? or should it be resource?
        - username should be immutable.
*/

module townesquare::user {
    use aptos_framework::event;
    use aptos_std::type_info;
    use std::signer;
    use std::string::{Self, String};
    
    friend townesquare::core;
    friend townesquare::post;

    // ------
    // Errors
    // ------

    /// The user already exists
    const EUSER_EXISTS: u64 = 1;
    /// The user does not exist
    const EUSER_DOES_NOT_EXIST: u64 = 2;
    /// The user is already of the inputted type
    const EUSER_ALREADY_OF_TYPE: u64 = 3;
    /// The user type is invalid
    const EINVALID_USER_TYPE: u64 = 4;
    /// The user has not the inputted type
    const EUSER_OF_TYPE_DOES_NOT_EXIST: u64 = 5;
    /// The caller does not have access permission
    const EINVALID_ACCESS: u64 = 6;
    /// The types should be different
    const ETYPES_SHOULD_BE_DIFFERENT: u64 = 7;
    /// The user has no type
    const EUSER_HAS_NO_TYPE: u64 = 8;
    /// The post tracker does not exist
    const EPOST_TRACKER_DOES_NOT_EXIST: u64 = 9;

    // -------
    // Structs
    // -------

    /// Storage for user
    struct User has key {
        addr: address,  
        username: String    // immutable
    }

    // user types; user can have multiple types

    /// Global storage for personal user
    struct Personal has drop, store, key {}
    /// Global storage for creator user
    struct Creator has drop, store, key {}
    /// Global storage for moderator user
    struct Moderator has drop, store, key {}

    /// Post tracker; 
    struct PostTracker has key { 
        user_addr: address,
        total_posts_created: u64
    }

    /// Activity status
    struct Active has key {}
    struct Inactive has key {}

    // ------
    // Events
    // ------

    #[event]
    /// Event for user creation
    struct UserCreatedEvent has store, drop {
        user_addr: address,
        user_type: String
    }
    fun emit_user_created_event<Type: store + drop>(user_addr: address) {
        event::emit<UserCreatedEvent>(
            UserCreatedEvent {
                user_addr: user_addr,
                user_type: type_info::type_name<Type>()
            }
        )
    }

    // ----------------
    // Public functions
    // ----------------

    /// Create a new user
    public(friend) fun create_user_internal<T: store + drop>(
        signer_ref: &signer,
        username: String
    ) {
        let signer_addr = signer::address_of(signer_ref);

        let user_addr = signer_addr;
        if (!exists<User>(signer_addr)) {
            // init post tracker
            move_to(
                signer_ref,
                PostTracker {
                    user_addr: user_addr,
                    total_posts_created: 0
                }
            );
            // user is inactive by default
            move_to(signer_ref, Inactive {});
            move_to(
                signer_ref,
                User {
                    addr: signer_addr,
                    username,
                }
            );
        };
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // assert personal user doesn't exist
            assert!(!exists<Personal>(signer_addr), EUSER_ALREADY_OF_TYPE);
            // move type resource under signer's address
            move_to(signer_ref, Personal {});
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // move type resource under signer's address
            move_to(signer_ref, Creator {});
        } else {
            // assert moderator user doesn't exist
            assert!(!exists<Moderator>(signer_addr), EUSER_ALREADY_OF_TYPE);
            // move type resource under signer's address
            move_to(signer_ref, Moderator {});
        };
        // emit event
        emit_user_created_event<T>(signer_addr);
    }

    /// Add type to user
    public(friend) fun add_user_type_internal<T>(
        signer_ref: &signer
    ) {
        let signer_addr = signer::address_of(signer_ref);
        // assert user exists
        assert_user_exists(signer_addr);
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Personal>(signer_addr), EUSER_ALREADY_OF_TYPE);
            move_to(signer_ref, Personal {});
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Creator>(signer_addr), EUSER_ALREADY_OF_TYPE);
            move_to(signer_ref, Creator {});
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // assert signer is moderator or ts
            assert!(
                exists<Moderator>(signer_addr) ||
                signer_addr == @townesquare,
                EINVALID_ACCESS
            );
            // assert user doesn't exist under this type
            assert!(!exists<Moderator>(signer_addr), EUSER_ALREADY_OF_TYPE);
            move_to(signer_ref, Moderator {});
        } else { abort(EINVALID_USER_TYPE) }
    }

    /// Delete a user type
    public(friend) fun delete_user_type_internal<T>(
        signer_ref: &signer
    ) acquires Creator, Moderator, Personal {
        let signer_addr = signer::address_of(signer_ref);
        // assert user exists
        assert_user_exists(signer_addr);
        // based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // assert user does exist under this type
            assert!(exists<Personal>(signer_addr), EUSER_OF_TYPE_DOES_NOT_EXIST);
            // assert user has atleast one type
            assert!(
                exists<Creator>(signer_addr) ||
                exists<Moderator>(signer_addr),
                EUSER_HAS_NO_TYPE
            );
            // remove T type from user
            Personal {} = move_from<Personal>(signer_addr);
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // assert user does exist under this type
            assert!(exists<Creator>(signer_addr), EUSER_OF_TYPE_DOES_NOT_EXIST);
            // assert user has atleast one type
            assert!(
                exists<Personal>(signer_addr) ||
                exists<Moderator>(signer_addr),
                EUSER_HAS_NO_TYPE
            );
            // remove T type from user
            Creator {} = move_from<Creator>(signer_addr);
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // assert user does exist under this type
            assert!(exists<Moderator>(signer_addr), EUSER_OF_TYPE_DOES_NOT_EXIST);
            // assert user has atleast one type
            assert!(
                exists<Personal>(signer_addr) ||
                exists<Creator>(signer_addr),
                EUSER_HAS_NO_TYPE
            );
            // remove T type from user
            Moderator {} = move_from<Moderator>(signer_addr);
        } else { abort(EINVALID_USER_TYPE) }
    }

    /// Delete a user alongside all its types
    public(friend) fun delete_user_internal(
        signer_ref: &signer
    ) acquires User, Creator, Moderator, Personal, PostTracker {
        let signer_addr = signer::address_of(signer_ref);
        // if user is of type Personal
        if (is_user_of_type<Personal>(signer_addr) == true) {           
            Personal {} = move_from<Personal>(signer_addr);
        };
        // if user is of type Creator
        if (is_user_of_type<Creator>(signer_addr) == true) {
            Creator {} = move_from<Creator>(signer_addr);
        };
        // if user is of type Moderator
        if (is_user_of_type<Moderator>(signer_addr) == true) {
            Moderator {} = move_from<Moderator>(signer_addr);
        };
        // delete user resource
        User { addr: _, username: _ } = move_from<User>(signer_addr);
        // delete post tracker
        delete_post_tracker(signer_ref);
        // TODO: delete posts; should be done in core?
    }

    // -------
    // Asserts
    // -------
    
    /// assert user exists; checks if users exists under any type
    public fun assert_user_exists(addr: address) {
        assert!(exists<User>(addr), EUSER_DOES_NOT_EXIST);
    }

    /// assert user does not exist; assert user address does not exist under any type
    public fun assert_user_does_not_exist(addr: address) {
        assert!(!exists<User>(addr), EUSER_EXISTS);
    }

    // ---------
    // Accessors
    // ---------

    /// returns User of type Personal
    public(friend) fun get_username<T>(
        signer_ref: &signer,
        user_addr: address
    ): String acquires User {
        let signer_addr = signer::address_of(signer_ref);
        assert_user_exists(signer_addr);
        // if type in personal
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            is_user_of_type<Personal>(user_addr);
            borrow_global<User>(user_addr).username
        }
        // if type in creator
        else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            is_user_of_type<Creator>(user_addr);
            borrow_global<User>(user_addr).username
        }
        // if type in moderator
        else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            is_user_of_type<Moderator>(user_addr);
            borrow_global<User>(user_addr).username
        } else { string::utf8(b"") }
    }

    /// Change user's activity status from X to Y
    fun change_activity_status<X, Y>(signer_ref: &signer) acquires Active, Inactive {
        assert!(type_info::type_of<X>() != type_info::type_of<Y>(), ETYPES_SHOULD_BE_DIFFERENT);
        // from Inactive to Active
        if ( type_info::type_of<X>() == type_info::type_of<Inactive>() ) {  
            // TODO: assert atleast one transaction has been made from the signer's address
            move_to(signer_ref, Active {});
            Inactive {} = move_from<Inactive>(signer::address_of(signer_ref));
        // from Active to Inactive
        } else if ( type_info::type_of<X>() == type_info::type_of<Active>()) {
            move_to(signer_ref, Inactive {});
            Active {} = move_from<Active>(signer::address_of(signer_ref));
        } else { abort(EINVALID_USER_TYPE) }
    }

    // --------------
    // View Functions
    // --------------

    // User
    #[view]
    /// Get user of type personal from address
    public fun get_personal_from_address(
        maybe_user_addr: address
    ): (User, Personal) acquires User {
        assert_user_exists(maybe_user_addr);
        let user_resource = borrow_global<User>(maybe_user_addr);
        (
            User {
                addr: user_resource.addr,
                username: user_resource.username
            }, Personal {}
        )
    }

    #[view]
    /// Get user of type creator from address
    public fun get_creator_from_address(
        maybe_user_addr: address
    ): (User, Creator)acquires User {
        assert_user_exists(maybe_user_addr);
        assert!(exists<Creator>(maybe_user_addr), EUSER_OF_TYPE_DOES_NOT_EXIST);
        let user_resource = borrow_global<User>(maybe_user_addr);
        (
            User {
                addr: user_resource.addr,
                username: user_resource.username
            }, Creator {}
        )
    }

    #[view]
    /// Get user of type moderator from address
    public fun get_moderator_from_address(
        maybe_user_addr: address
    ): (User, Moderator) acquires User {
        assert_user_exists(maybe_user_addr);
        let user_resource = borrow_global<User>(maybe_user_addr);
        (
            User {
                addr: user_resource.addr,
                username: user_resource.username
            }, Moderator {}
        )
    }

    #[view]
    /// Get username
    public fun get_username_from_address(user_addr: address): String acquires User {
        // assert user exists
        assert_user_exists(user_addr);
        borrow_global<User>(user_addr).username
    }

    #[view]
    /// verify an address is a user giving type and address; callable by anyone
    public fun is_user(
        addr: address
    ): bool { exists<User>(addr) }

    #[view]
    /// User exists and of type T
    public fun is_user_of_type<T>(maybe_user_addr: address): bool {
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            exists<Personal>(maybe_user_addr)
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            exists<Creator>(maybe_user_addr)
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            exists<Moderator>(maybe_user_addr)
        } else { false }
    }

    #[view]
    /// Returns the total number of posts created by a user; TODO: callable by anyone?
    public fun get_created_posts_total_number(
        user_addr: address
    ): u64 acquires PostTracker {
        assert!(exists<PostTracker>(user_addr), EPOST_TRACKER_DOES_NOT_EXIST);
        borrow_global<PostTracker>(user_addr).total_posts_created
    }

    #[view]
    /// Checks if signer is active
    public fun signer_is_active(signer_ref: &signer): bool {
        address_is_active(signer::address_of(signer_ref))
    }

    #[view]
    /// Checks if signer is inactive
    public fun signer_is_inactive(signer_ref: &signer): bool {
        address_is_inactive(signer::address_of(signer_ref))
    }

    #[view]
    /// Checks if user is an active
    public fun address_is_active(user_addr: address): bool {
        exists<Active>(user_addr)
    }

    #[view]
    /// Checks if user is inactive
    public fun address_is_inactive(user_addr: address): bool {
        exists<Inactive>(user_addr)
    }

    // --------
    // mutators
    // --------

    /// Change user type from X to Y
    public(friend) fun change_user_type<X, Y>(
        signer_ref: &signer
    ) acquires Creator, Moderator, Personal {
        let signer_addr = signer::address_of(signer_ref);
        // user exists
        assert_user_exists(signer_addr);
        // X and Y should be different types
        assert!(type_info::type_of<X>() != type_info::type_of<Y>(), ETYPES_SHOULD_BE_DIFFERENT);
        // Y should not be Moderator
        assert!(type_info::type_of<Y>() != type_info::type_of<Moderator>(), EINVALID_USER_TYPE);
        // if X is personal
        if (type_info::type_of<X>() == type_info::type_of<Personal>()) {
            // assert user is personal
            assert!(exists<Personal>(signer_addr), EUSER_OF_TYPE_DOES_NOT_EXIST); // already Personal user
            assert!(!exists<Creator>(signer_addr), EUSER_ALREADY_OF_TYPE); // not Creator user
            // add Y type to user
            add_user_type_internal<Personal>(signer_ref);
            // remove X type from user
            delete_user_type_internal<X>(signer_ref);

        // if X is Creator
        } else if (type_info::type_of<X>() == type_info::type_of<Creator>()) {
            assert!(exists<Creator>(signer_addr), EUSER_OF_TYPE_DOES_NOT_EXIST); // already Creator user
            assert!(!exists<Personal>(signer_addr), EUSER_ALREADY_OF_TYPE); // not Personal user
            // add Y type to user
            add_user_type_internal<Personal>(signer_ref);
            // remove X type from user
            delete_user_type_internal<X>(signer_ref);
        }
    }

    /// Change user's activity status from Inactive to Active
    public(friend) fun change_activity_status_from_inactive_to_active(
        signer_ref: &signer
    ) acquires Active, Inactive {
        change_activity_status<Inactive, Active>(signer_ref);
    }

    // Change user's activity status from Active to Inactive
    public(friend) fun change_activity_status_from_active_to_inactive(
        signer_ref: &signer
    ) acquires Active, Inactive {
        change_activity_status<Active, Inactive>(signer_ref);
    }

    // increment post tracker; this will increment the total_posts_created and return it
    public(friend) fun increment_post_tracker(
        signer_ref: &signer
    ): u64 acquires PostTracker {
        let post_tracker = borrow_global_mut<PostTracker>(signer::address_of(signer_ref));
        post_tracker.total_posts_created = post_tracker.total_posts_created + 1;
        post_tracker.total_posts_created
    }

    /// decrement post tracker; this will decrement the total_posts_created and return it
    public(friend) fun decrement_post_tracker(
        signer_ref: &signer
    ): u64 acquires PostTracker {
        let post_tracker = borrow_global_mut<PostTracker>(signer::address_of(signer_ref));
        post_tracker.total_posts_created = post_tracker.total_posts_created - 1;
        post_tracker.total_posts_created
    }

    /// delete post tracker
    fun delete_post_tracker(
        signer_ref: &signer
    ) acquires PostTracker {
        let signer_addr = signer::address_of(signer_ref);
        assert!(exists<PostTracker>(signer_addr), EPOST_TRACKER_DOES_NOT_EXIST);
        let post_tracker = move_from<PostTracker>(signer_addr);
        let PostTracker { user_addr: _, total_posts_created: _ } = post_tracker;
    }


    // ----------
    // Unit Tests
    // ----------

    #[test_only]
    use aptos_framework::account;
    #[test_only]
    use aptos_framework::aptos_coin::AptosCoin;
    #[test_only]
    use aptos_framework::managed_coin;
    #[test_only]
    use std::option;
    #[test_only]
    use townesquare::referral;

    /* 
        ----------------------------- Private tests --------------------------------

        these functions are limitied to this module and cannot be used in other once
    */

    #[test(user = @0x123)]
    // create personal user
    fun create_personal_user_test(user: &signer) acquires PostTracker {
        create_user_internal<Personal>(user, string::utf8(b"test"));
        // assert user exists
        assert_user_exists(signer::address_of(user));
        // assert user is of type Personal and not of type Creator or Moderator
        assert!(exists<Personal>(signer::address_of(user)), 1);
        assert!(!exists<Creator>(signer::address_of(user)), 1);
        assert!(!exists<Moderator>(signer::address_of(user)), 1);
        // assert user is inactive
        assert!(address_is_inactive(signer::address_of(user)), 1);
        // assert post tracker is created with 0 total_posts_created
        assert!(get_created_posts_total_number(signer::address_of(user)) == 0, 1);
    }

    
    #[test(user = @0x123)]
    // create creator user
    fun create_creator_user_test(user: &signer) acquires PostTracker {
        create_user_internal<Creator>(user, string::utf8(b"test"));
        // assert user exists
        assert_user_exists(signer::address_of(user));
        // assert user is of type Creator and not of type Personal or Moderator
        assert!(exists<Creator>(signer::address_of(user)), 1);
        assert!(!exists<Personal>(signer::address_of(user)), 1);
        assert!(!exists<Moderator>(signer::address_of(user)), 1);
        // assert user is inactive
        assert!(address_is_inactive(signer::address_of(user)), 1);
        // assert post tracker is created with 0 total_posts_created
        assert!(get_created_posts_total_number(signer::address_of(user)) == 0, 1);
    }

    
    #[test(user = @0x123)]
    // create moderator user
    fun create_moderator_user_test_(user: &signer) acquires PostTracker {
        create_user_internal<Moderator>(user, string::utf8(b"test"));
        // assert user exists
        assert_user_exists(signer::address_of(user));
        // assert user is of type Moderator and not of type Personal or Creator
        assert!(exists<Moderator>(signer::address_of(user)), 1);
        assert!(!exists<Personal>(signer::address_of(user)), 1);
        assert!(!exists<Creator>(signer::address_of(user)), 1);
        // assert user is inactive
        assert!(address_is_inactive(signer::address_of(user)), 1);
        // assert post tracker is created with 0 total_posts_created
        assert!(get_created_posts_total_number(signer::address_of(user)) == 0, 1);
    } 

    #[test(user = @0x123)]
    fun add_creator_type_to_personal_test(user: &signer) acquires PostTracker {
        create_personal_user_test(user);
        // add user type: Creator
        add_user_type_internal<Creator>(user);
        // assert user is of type Personal and Creator and not of type Moderator
        assert!(exists<Personal>(signer::address_of(user)), 1);
        assert!(exists<Creator>(signer::address_of(user)), 1);
        assert!(!exists<Moderator>(signer::address_of(user)), 1);
        // TODO: Post tracker remains the same?
    }

    #[test(user = @0x123)]
    // delete_user_type_internal
    fun delete_creator_type_from_personal_test(
        user: &signer
    ) acquires Creator, Moderator, Personal, PostTracker {
        create_personal_user_test(user);
        // add user type: Creator
        add_user_type_internal<Creator>(user);
        // assert user is of type Personal and Creator and not of type Moderator
        assert!(exists<Personal>(signer::address_of(user)), 1);
        assert!(exists<Creator>(signer::address_of(user)), 1);
        assert!(!exists<Moderator>(signer::address_of(user)), 1);
        // delete user type: Creator
        delete_user_type_internal<Creator>(user);
        // assert user is of type Personal and not of type Creator or Moderator
        assert!(exists<Personal>(signer::address_of(user)), 1);
        assert!(!exists<Creator>(signer::address_of(user)), 1);
        assert!(!exists<Moderator>(signer::address_of(user)), 1);
    }

    #[test(user = @0x123)]
    #[expected_failure(abort_code = 3, location = Self)]   // TODO: change code when implementing ERRORS consts
    // Create already existing user of type personal
    fun create_existing_user_test(user: &signer) acquires PostTracker {
        create_personal_user_test(user);
        // assert user exists
        assert_user_exists(signer::address_of(user));
        // assert user is of type Personal and not of type Creator or Moderator
        assert!(exists<Personal>(signer::address_of(user)), 1);
        assert!(!exists<Creator>(signer::address_of(user)), 1);
        assert!(!exists<Moderator>(signer::address_of(user)), 1);
        // assert user is inactive
        assert!(address_is_inactive(signer::address_of(user)), 1);
        // assert post tracker is created with 0 total_posts_created
        assert!(get_created_posts_total_number(signer::address_of(user)) == 0, 1);
        create_personal_user_test(user);
    }

    /* 
        ----------------------------- Public tests --------------------------------

        These functions are public and can be used in other modules.

        TODO: don't implement asserts when creating funcs for users 
        as doing so won't allow for adding more types in the future
    */
    
    #[test(user = @0x123)]
    // create_user_internal
    public fun create_personal_user_for_test(user: &signer) {
        account::create_account_for_test(signer::address_of(user));
        managed_coin::register<AptosCoin>(user);
        // TODO: should not be using internal func
        create_user_internal<Personal>(user, string::utf8(b"test"));
        // Create referral; doesn't have referral so returns none
        referral::create_referral(user, string::utf8(b"test"), option::none());
        assert!(exists<Personal>(signer::address_of(user)), 1);
    }

    #[test(user = @0x123, referrer_addr = @0x456)]
    // create_user_internal with referrer
    public fun create_personal_user_with_referrer_for_test(user: &signer, referrer_addr: address) {
        account::create_account_for_test(signer::address_of(user));
        managed_coin::register<AptosCoin>(user);
        // TODO: should not be using internal func
        create_user_internal<Personal>(user, string::utf8(b"test"));
        // Create referral
        let referrer = option::none<address>();
        option::fill<address>(&mut referrer, referrer_addr);
        referral::create_referral(user, string::utf8(b"test"), referrer);
        assert!(exists<Personal>(signer::address_of(user)), 1);
    }

    #[test(user = @0x123)]
    public fun create_moderator_user_test(user: &signer) {
        account::create_account_for_test(signer::address_of(user));
        managed_coin::register<AptosCoin>(user);
        create_user_internal<Moderator>(user, string::utf8(b"test"));
        // Create referral; doesn't have referral so returns none
        referral::create_referral(user, string::utf8(b"test"), option::none());
        assert!(exists<Moderator>(signer::address_of(user)), 1);
    }

    #[test(user = @0x123)]
    // delete_user_internal
    public fun delete_user_test(
        user: &signer
    ) acquires Creator, Moderator, Personal, PostTracker, User {
        create_user_internal<Personal>(user, string::utf8(b"test"));
        add_user_type_internal<Creator>(user);
        // assert user exists
        is_user_of_type<Personal>(signer::address_of(user));
        is_user_of_type<Creator>(signer::address_of(user));
        // delete user
        delete_user_internal(user);
        // assert user does not exist
        assert!(!exists<Personal>(signer::address_of(user)), 1);
        assert!(!exists<Creator>(signer::address_of(user)), 1);
        assert!(!exists<Moderator>(signer::address_of(user)), 1);
    }

    #[test(user = @0x123)]
    // change activity status
    public fun change_activity_status_test(user: &signer) acquires Active, Inactive {
        create_user_internal<Personal>(user, string::utf8(b"test"));
        // assert user is inactive
        assert!(address_is_inactive(signer::address_of(user)), 1);
        // change activity status from inactive to active
        change_activity_status_from_inactive_to_active(user);
        // assert user is active
        assert!(address_is_active(signer::address_of(user)), 1);
        // change activity status from active to inactive
        change_activity_status_from_active_to_inactive(user);
        // assert user is inactive
        assert!(address_is_inactive(signer::address_of(user)), 1);
    }
}