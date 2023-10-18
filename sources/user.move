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
        - add caps so that user can't self-promote to moderator
        - add unit tests
        - add big table for posts; would be useful in case off chain data is lost
        or in maintenance, in that case, we can get table of posts, it can be costy tho.
        - authorized borrow to moderators and list of connected users
*/

module townesquare::user {
    use aptos_std::type_info;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{Self, String};
    
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

    // Post tracker; 
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
    public(friend) fun add_user_type<T>(
        signer_ref: &signer
    ) {
        let signer_addr = signer::address_of(signer_ref);
        // assert user exists
        assert_user_exists(signer_addr);
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Personal>(signer_addr), 1);
            move_to(signer_ref, Personal {});
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Creator>(signer_addr), 1);
            move_to(signer_ref, Creator {});
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // assert signer is moderator or ts
            assert!(
                exists<Moderator>(signer_addr) ||
                signer_addr == @townesquare,
                1
            );
            // assert user doesn't exist under this type
            assert!(!exists<Moderator>(signer_addr), 1);
            move_to(signer_ref, Moderator {});
        } else { assert!(false, 1); }
    }

    // Delete a user alongside all its types
    public(friend) fun delete_user(
        signer_ref: &signer
    ) acquires User, Creator, Moderator, Personal {
        let signer_addr = signer::address_of(signer_ref);
        // if user is of type Personal
        if (is_user_of_type<Personal>(signer_addr) == true) {
            User { addr: _, pfp: _, username: _, type: _ } = move_from<User<Personal>>(signer_addr);
            Personal {} = move_from<Personal>(signer_addr);
        }
        // if user is of type Creator
        else if (is_user_of_type<Creator>(signer_addr) == true) {
            User { addr: _, pfp: _, username: _, type: _ } = move_from<User<Creator>>(signer_addr);
            Creator {} = move_from<Creator>(signer_addr);
        }
        // if user is of type Moderator
        else if (is_user_of_type<Moderator>(signer_addr) == true) {
            User { addr: _, pfp: _, username: _, type: _ } = move_from<User<Moderator>>(signer_addr);
            Moderator {} = move_from<Moderator>(signer_addr);
        }
        // TODO: delete posts and post tracker
    }

    // Delete a user type
    public(friend) fun delete_user_type<T>(
        signer_ref: &signer
    ) acquires Creator, Moderator, Personal {
        let signer_addr = signer::address_of(signer_ref);
        // assert user exists
        assert_user_exists(signer_addr);
        // based on type
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

    // returns User of type Personal
    public(friend) fun get_username<T>(
        signer_ref: &signer,
        user_addr: address
    ): String acquires User {
        let signer_addr = signer::address_of(signer_ref);
        assert_user_exists(signer_addr);
        // if type in personal
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            is_user_of_type<Personal>(user_addr);
            borrow_global<User<Personal>>(user_addr).username
        }
        // if type in creator
        else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            is_user_of_type<Creator>(user_addr);
            borrow_global<User<Creator>>(user_addr).username
        }
        // if type in moderator
        else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            is_user_of_type<Moderator>(user_addr);
            borrow_global<User<Moderator>>(user_addr).username
        } else { string::utf8(b"") }
    }

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

    // User
    #[view]
    // Get user of type personal from address
    public fun get_personal_from_address(
        maybe_user_addr: address
    ): User<Personal> acquires User {
        assert!(exists<User<Personal>>(maybe_user_addr), 1);    // user does not exist under this type
        let user_resource = borrow_global<User<Personal>>(maybe_user_addr);
        User<Personal> {
            addr: user_resource.addr,
            pfp: user_resource.pfp,
            type: Personal {},
            username: user_resource.username
        } 
    }

    #[view]
    // Get user of type creator from address
    public fun get_creator_from_address(
        maybe_user_addr: address
    ): User<Creator> acquires User {
        assert!(exists<User<Creator>>(maybe_user_addr), 1);    // user does not exist under this type
        let user_resource = borrow_global<User<Creator>>(maybe_user_addr);
        User<Creator> {
            addr: user_resource.addr,
            pfp: user_resource.pfp,
            type: Creator {},
            username: user_resource.username
        } 
    }

    #[view]
    // Get user of type moderator from address
    public fun get_moderator_from_address(
        maybe_user_addr: address
    ): User<Moderator> acquires User {
        assert!(exists<User<Moderator>>(maybe_user_addr), 1);    // user does not exist under this type
        let user_resource = borrow_global<User<Moderator>>(maybe_user_addr);
        User<Moderator> {
            addr: user_resource.addr,
            pfp: user_resource.pfp,
            type: Moderator {},
            username: user_resource.username
        } 
    }

    #[view]
    // Get personal username from address
    public fun get_personal_username(
        maybe_user: address
    ): String acquires User {
        assert!(exists<User<Personal>>(maybe_user), 1);    // user does not exist under this type
        borrow_global<User<Personal>>(maybe_user).username
    }

    #[view]
    // Get creator username from address
    public fun get_creator_username(
        maybe_user: address
    ): String acquires User {
        assert!(exists<User<Creator>>(maybe_user), 1);    // user does not exist under this type
        borrow_global<User<Creator>>(maybe_user).username
    }

    #[view]
    // Get moderator username from address
    public fun get_moderator_username(
        maybe_user: address
    ): String acquires User {
        assert!(exists<User<Moderator>>(maybe_user), 1);    // user does not exist under this type
        borrow_global<User<Moderator>>(maybe_user).username
    }

    #[view]
    // Get personal pfp from address
    public fun get_user_pfp(
        maybe_user: address
    ): address acquires User {
        assert!(exists<User<Personal>>(maybe_user), 1);    // user does not exist under this type
        borrow_global<User<Personal>>(maybe_user).pfp
    }

    // #[view]
    // // Get user pfp
    // public fun get_user_pfp<T: drop + store + key>(
    //     signer_ref: &signer
    // ): address acquires User {
    //     // let user = authorized_borrow<User<T>>(signer_ref);
    //     // user.pfp
    // }

    // #[view]
    // // Get user username
    // public fun get_username<T: drop + store + key>(
    //     signer_ref: &signer
    // ): String acquires User {
    //     // let user = authorized_borrow<User<T>>(signer_ref);
    //     // user.username
    // }

    #[view]
    // verify an address is a user
    public fun is_user<T: drop + store + key>(
        addr: address
    ): bool {
        exists<User<T>>(addr)
    }

    #[view]
    // User exists and of type T
    public fun is_user_of_type<T>(
        maybe_user_addr: address
    ): bool {
        assert_user_exists(maybe_user_addr);
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            exists<Personal>(maybe_user_addr)
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            exists<Creator>(maybe_user_addr)
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            exists<Moderator>(maybe_user_addr)
        } else { false }
    }

    // #[view]
    // return all user's types
    // TODO

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

    // Change user type from X to Y
    public(friend) fun change_user_type<X, Y>(
        signer_ref: &signer
    ) acquires Creator, Moderator, Personal {
        let signer_addr = signer::address_of(signer_ref);
        // user exists
        assert_user_exists(signer_addr);
        // X and Y should be different types
        assert!(type_info::type_of<X>() != type_info::type_of<Y>(), 1);
        // if X is personal
        if (type_info::type_of<X>() == type_info::type_of<Personal>()) {
            // assert user is personal
            assert!(exists<Personal>(signer_addr), 1); // already Personal user
            assert!(!exists<Creator>(signer_addr), 1); // not Creator user
            // add Y type to user
            add_user_type<Personal>(signer_ref);
            // remove X type from user
            delete_user_type<X>(signer_ref);

        // if X is Creator
        } else if (type_info::type_of<X>() == type_info::type_of<Creator>()) {
            assert!(exists<Creator>(signer_addr), 1); // already Creator user
            assert!(!exists<Personal>(signer_addr), 1); // not Personal user
            // add Y type to user
            add_user_type<Personal>(signer_ref);
            // remove X type from user
            delete_user_type<X>(signer_ref);
        }
        // if X is creator
        // TODO
        
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

    // delete post tracker
    fun delete_post_tracker(
        signer_ref: &signer
    ) acquires PostTracker {
        let signer_addr = signer::address_of(signer_ref);
        assert!(exists<PostTracker>(signer_addr), 1);
        let post_tracker = move_from<PostTracker>(signer_addr);
        let PostTracker { user_addr: _, total_posts_created: _ } = post_tracker;
    }
}