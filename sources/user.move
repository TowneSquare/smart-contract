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
*/

module townesquare::user {
    use aptos_std::type_info;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    
    friend townesquare::core;

    // -------
    // Structs
    // -------

    // Storage for user
    struct User has key {
        addr: address,  // immutable for security reasons
        pfp: address,   // address of nft
        username: String    // immutable?
    }

    // user types; user can have multiple types
    struct Personal has key {}
    struct Creator has key {}
    struct Moderator has key {}

    // ---------
    // Internals
    // ---------

    // Create a new user
    // TODO: should return a user struct and type?
    public(friend) fun create_user_resource<T>(
        addr_signer_ref: &signer,
        pfp: address,
        username: String
    ) {
        let signer_addr = signer::address_of(addr_signer_ref);
        // assert user doesn't exist
        assert!(!exists<User>(signer_addr), 1);
        // TODO: init module from tx contracts
        // TODO: store address in a global struct
        // move User resource under signer's account
        move_to(
            addr_signer_ref,
            User {
                addr: signer_addr,
                pfp: pfp,
                username: username
            }
        );
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // TODO: event returning the user and its type
            move_to(
                addr_signer_ref,
                Personal {}
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // TODO: event returning the user and its type
            move_to(
                addr_signer_ref,
                Creator {}
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // TODO: event returning the user and its type
            move_to(
                addr_signer_ref,
                Moderator {}
            )
        } else { assert!(false, 1); }
    }

    // Add type to user
    public(friend) fun add_type<T: key>(
        addr_signer_ref: &signer
    ) {
        let signer_addr = signer::address_of(addr_signer_ref);
        // assert user exists
        assert!(exists<User>(signer_addr), 1);
        // store based on type
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Personal>(signer_addr), 1);
            move_to(
                addr_signer_ref,
                Personal {}
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Creator>(signer_addr), 1);
            move_to(
                addr_signer_ref,
                Creator {}
            )
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            // assert user doesn't exist under this type
            assert!(!exists<Moderator>(signer_addr), 1);
            move_to(
                addr_signer_ref,
                Moderator {}
            )
        } else { assert!(false, 1); }
    }

    // Delete a user with type
    public(friend) fun delete_user_resource<T>(
        addr_signer_ref: &signer
    ) acquires User {
        let signer_addr = signer::address_of(addr_signer_ref);
        // assert user exists
        assert!(exists<User>(signer_addr), 1);
        // let user = move_from<User>(signer_addr);
        let User { addr: _, pfp: _, username: _ } = move_from<User>(signer_addr);
    }

    // Delete a user type
    public(friend) fun delete_type<T: key>(
        addr_signer_ref: &signer
    ) acquires Creator, Moderator, Personal {
        let signer_addr = signer::address_of(addr_signer_ref);
        // assert user exists
        assert!(exists<User>(signer_addr), 1);
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
            let Personal {} = move_from<Personal>(signer_addr);
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
            let Creator {} = move_from<Creator>(signer_addr);
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
            let Moderator {} = move_from<Moderator>(signer_addr);
        } else { assert!(false, 1); }
    }

    // ---------
    // Accessors
    // ---------

    // for getters
    inline fun authorized_borrow<T: key>(addr_signer_ref: &signer): &T {
        let signer_addr = signer::address_of(addr_signer_ref);
        assert!(exists<T>(signer_addr), 1);
        borrow_global<T>(signer_addr)
        // TODO: borrow from users
    }

    // for setters
    inline fun authorized_borrow_mut<T: key>(addr_signer_ref: &signer): &mut T {
        let signer_addr = signer::address_of(addr_signer_ref);
        assert!(exists<T>(signer_addr), 1);
        borrow_global_mut<T>(signer_addr)
    }

    // --------------
    // View Functions
    // --------------

    #[view]
    // Get user address
    public fun get_user_address(
        addr_signer_ref: &signer
    ): address acquires User {
        let user = authorized_borrow<User>(addr_signer_ref);
        user.addr
    }

    #[view]
    // Get user pfp
    public fun get_user_pfp(
        addr_signer_ref: &signer
    ): address acquires User {
        let user = authorized_borrow<User>(addr_signer_ref);
        user.pfp
    }

    #[view]
    // Get user username
    public fun get_user_username(
        addr_signer_ref: &signer
    ): String acquires User {
        let user = authorized_borrow<User>(addr_signer_ref);
        user.username
    }

    #[view]
    // User is of type T
    public fun is_of_type<T: key>(
        addr_signer_ref: &signer
    ): bool {
        let signer_addr = signer::address_of(addr_signer_ref);
        // check based on T
        if (type_info::type_of<T>() == type_info::type_of<Personal>()) {
            exists<Personal>(signer_addr)
        } else if (type_info::type_of<T>() == type_info::type_of<Creator>()) {
            exists<Creator>(signer_addr)
        } else if (type_info::type_of<T>() == type_info::type_of<Moderator>()) {
            exists<Moderator>(signer_addr)
        } else { false }
    }

    // --------
    // mutators
    // --------

    // Change username
    public(friend) fun set_username(
        addr_signer_ref: &signer,
        new_username: String
    ) acquires User {
        let user = authorized_borrow_mut<User>(addr_signer_ref);
        user.username = new_username;
    }

    // Change pfp 
    public(friend) fun set_pfp(
        addr_signer_ref: &signer,
        new_pfp: address
    ) acquires User {
        let user = authorized_borrow_mut<User>(addr_signer_ref);
        user.pfp = new_pfp;
    }

    // TODO: Change user type from X to Y
    public(friend) fun set_user_type<X, Y>(
        addr_signer_ref: &signer
    ) {
        let signer_addr = signer::address_of(addr_signer_ref);
        // assert types are not the same
        assert!(type_info::type_of<X>() != type_info::type_of<Y>(), 1);
        
    }

    // 

}