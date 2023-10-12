/*
    Module for user
    - user types: personal, creator, moderator

        Personal
        - can create posts
        - can connect to other users
        - can use ts features
        - has limited number of connections

        Creator
        - can create posts
        - can connect to other users
        - can use ts features
        - has unlimited number of connections

        Moderator
        - tbd

    TODO:
        - add unit tests
        - add big table for posts; would be useful in case off chain data is lost
        or in maintenance, in that case, we can get table of posts, it can be costy tho.
        - authorized borrow to moderators and list of connected users
*/

module townesquare::user {
    use aptos_std::type_info;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    
    friend townesquare::core;
    friend townesquare::post;

    // -------
    // Structs
    // -------

    // Storage for user
    struct User<T> has key {
        addr: address,  // immutable for security reasons
        pfp: address,   // address of nft
        type: T,        // type of user; can be multiple
        username: String    // immutable?
    }

    // user types; user can have multiple types
    struct Personal has drop, store, key {}
    struct Creator has drop, store, key {}
    struct Moderator has drop, store, key {}

    // Post tracker; used to get creation_num for GUID
    struct PostTracker has key { 
        user_addr: address,
        total_posts_created: u64,
        // TODO: post_created_events: ,
        // TODO: post_deleted_events: ,
    }

    // ---------
    // Internals
    // ---------

    // Create a new user
    // TODO: should return a user struct and address; address to store it in a global struct
    public(friend) fun create_user_internal<T>(
        signer_ref: &signer,
        pfp: address,
        username: String
    ) {
        let signer_addr = signer::address_of(signer_ref);
        // assert user doesn't exist
        assert_user_does_not_exist(signer_addr);
        // TODO: init module from tx contracts
        // TODO: store address in a global struct
        let user_addr = signer_addr;
        // init post tracker
        move_to(
            signer_ref,
            PostTracker {
                user_addr: user_addr,
                total_posts_created: 0
            }
        );
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // TODO: event returning the user and its type
            move_to(
                signer_ref,
                User {
                    addr: signer_addr,
                    pfp: pfp,
                    type: Personal {},
                    username: username
                }
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // TODO: event returning the user and its type
            move_to(
                signer_ref,
                User {
                    addr: signer_addr,
                    pfp: pfp,
                    type: Creator {},
                    username: username
                }
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // TODO: event returning the user and its type
            move_to(
                signer_ref,
                User {
                    addr: signer_addr,
                    pfp: pfp,
                    type: Moderator {},
                    username: username
                }
            )
        } else { assert!(false, 1); }
    }

    // Add type to user
    public(friend) fun add_type<T>(
        signer_ref: &signer
    ) {
        let signer_addr = signer::address_of(signer_ref);
        // assert user exists
        assert_user_exists(signer_addr);
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Personal>(signer_addr), 1);
            move_to(
                signer_ref,
                Personal {}
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Creator>(signer_addr), 1);
            move_to(
                signer_ref,
                Creator {}
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Moderator>(signer_addr), 1);
            move_to(
                signer_ref,
                Moderator {}
            )
        } else { assert!(false, 1); }
    }

    // Delete a user alongside all its types
    public(friend) fun delete_user(
        signer_ref: &signer
    ) acquires User, Creator, Moderator, Personal {
        let signer_addr = signer::address_of(signer_ref);
        // assert user exists
        assert_user_exists(signer_addr);
        User { addr: _, pfp: _, username: _, type: _ } = move_from<User<Personal>>(signer_addr);
        User { addr: _, pfp: _, username: _, type: _ } = move_from<User<Creator>>(signer_addr);
        User { addr: _, pfp: _, username: _, type: _ } = move_from<User<Moderator>>(signer_addr);
        Personal {} = move_from<Personal>(signer_addr);
        Creator {} = move_from<Creator>(signer_addr);
        Moderator {} = move_from<Moderator>(signer_addr);
    }

    // Delete a user type
    public(friend) fun delete_type<T>(
        signer_ref: &signer
    ) acquires Creator, Moderator, Personal {
        let signer_addr = signer::address_of(signer_ref);
        // assert user exists
        assert_user_exists(signer_addr);
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // assert user does exist under this type
            assert!(exists<Personal>(signer_addr), 1);
            // assert user has atleast one type
            assert!(
                exists<Creator>(signer_addr) ||
                exists<Moderator>(signer_addr),
                1
            );
            // remove T type from user
            Personal {} = move_from<Personal>(signer_addr);
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // assert user does exist under this type
            assert!(exists<Creator>(signer_addr), 1);
            // assert user has atleast one type
            assert!(
                exists<Personal>(signer_addr) ||
                exists<Moderator>(signer_addr),
                1
            );
            // remove T type from user
            Creator {} = move_from<Creator>(signer_addr);
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // assert user does exist under this type
            assert!(exists<Moderator>(signer_addr), 1);
            // assert user has atleast one type
            assert!(
                exists<Personal>(signer_addr) ||
                exists<Creator>(signer_addr),
                1
            );
            // remove T type from user
            Moderator {} = move_from<Moderator>(signer_addr);
        } else { assert!(false, 1); }
    }


    // -------
    // Asserts
    // -------
    
    // assert user exists; checks if users exists under any type
    public fun assert_user_exists(addr: address) {
        assert!(
            exists<User<Personal>>(addr) ||
            exists<User<Creator>>(addr) ||
            exists<User<Moderator>>(addr),
            1
            );
    }

    // assert user does not exist; assert user address does not exist under any type
    public fun assert_user_does_not_exist(addr: address) {
        assert!(
            !exists<User<Personal>>(addr) &&
            !exists<User<Creator>>(addr) &&
            !exists<User<Moderator>>(addr),
            1
        );
    }

    // ---------
    // Accessors
    // ---------

    // for getters
    inline fun authorized_borrow<T: key>(signer_ref: &signer): &T {
        let signer_addr = signer::address_of(signer_ref);
        assert!(exists<T>(signer_addr), 1);
        borrow_global<T>(signer_addr)
        // TODO: borrow from users
    }

    // for setters
    inline fun authorized_borrow_mut<T: key>(signer_ref: &signer): &mut T {
        let signer_addr = signer::address_of(signer_ref);
        assert!(exists<T>(signer_addr), 1);
        borrow_global_mut<T>(signer_addr)
    }


    // --------------
    // View Functions
    // --------------

    #[view]
    // Get user address
    public fun get_user_address<T: drop + store + key>(
        signer_ref: &signer
    ): address acquires User {
        let user = authorized_borrow<User<T>>(signer_ref);
        user.addr
    }

    #[view]
    // Get user pfp
    public fun get_user_pfp<T: drop + store + key>(
        signer_ref: &signer
    ): address acquires User {
        let user = authorized_borrow<User<T>>(signer_ref);
        user.pfp
    }

    #[view]
    // Get user username
    public fun get_user_username<T: drop + store + key>(
        signer_ref: &signer
    ): String acquires User {
        let user = authorized_borrow<User<T>>(signer_ref);
        user.username
    }

    #[view]
    // verify an address is a user
    public fun is_user<T: drop + store + key>(
        addr: address
    ): bool {
        exists<User<T>>(addr)
    }

    #[view]
    // User is of type T
    public fun is_user_of_type<T: drop + store + key>(
        signer_ref: &signer
    ): bool {
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            exists<Personal>(signer::address_of(signer_ref))
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            exists<Creator>(signer::address_of(signer_ref))
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            exists<Moderator>(signer::address_of(signer_ref))
        } else { false }
    }

    #[view]
    // Returns the total number of posts created by a user; TODO: callable by anyone?
    public fun get_created_posts_total_number(
        user_addr: address
    ): u64 acquires PostTracker {
        assert!(exists<PostTracker>(user_addr), 1);
        borrow_global<PostTracker>(user_addr).total_posts_created
    }

    // --------
    // mutators
    // --------

    // Change username
    public(friend) fun set_username<T: drop + store + key>(
        signer_ref: &signer,
        new_username: String
    ) acquires User {
        let user = authorized_borrow_mut<User<T>>(signer_ref);
        user.username = new_username;
    }

    // Change pfp 
    public(friend) fun set_pfp<T: drop + store + key>(
        signer_ref: &signer,
        new_pfp: address
    ) acquires User {
        let user = authorized_borrow_mut<User<T>>(signer_ref);
        user.pfp = new_pfp;
    }

    // TODO: Change user type from X to Y
    public(friend) fun set_user_type<X, Y>(
        signer_ref: &signer
    ) {
        let signer_addr = signer::address_of(signer_ref);
        // assert types are not the same
        assert!(type_info::type_of<X>() != type_info::type_of<Y>(), 1);
        
    }

    // increment post tracker; this will increment the total_posts_created and return it
    public(friend) fun increment_post_tracker(
        signer_ref: &signer
    ): u64 acquires PostTracker {
        let post_tracker = authorized_borrow_mut<PostTracker>(signer_ref);
        post_tracker.total_posts_created = post_tracker.total_posts_created + 1;
        post_tracker.total_posts_created
    }

    // decrement post tracker; this will decrement the total_posts_created and return it
    public(friend) fun decrement_post_tracker(
        signer_ref: &signer
    ): u64 acquires PostTracker {
        let post_tracker = authorized_borrow_mut<PostTracker>(signer_ref);  // TODO: can be moderator?
        post_tracker.total_posts_created = post_tracker.total_posts_created - 1;
        post_tracker.total_posts_created
    }
}