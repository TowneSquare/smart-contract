/*
    Inspired from collection/nft relationship where
    nfts are all soulbound since we can't actually transfer posts ownership

    TODO: 
        - run verifications on TExt Posts to make sure it's UTF8
        - add encryption to private posts
*/

module townesquare::post {
    use aptos_framework::timestamp;
    use aptos_std::type_info;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    use townesquare::user::{Self, User};

    friend townesquare::core;

    // -------
    // Structs
    // -------

    // Global storage for posts; where T is type and V is visibility
    // TODO: should be global?
    struct Post<T, V> has key {
        user_addr: address,
        content: T,
        description: String,
        visibility: V,  // Public or Private
        timestamp: u64       
    }

    // Post types
    struct Audio has drop, store, key { content: String }    // uri
    struct Image has drop, store, key { content: String }    // uri
    struct Text has drop, store, key { content: String }
    struct Video has drop, store, key { content: String }    // uri

    // Post visibility
    struct Public has drop, store, key {}
    struct Private has drop, store, key {} // Neighbour nodes only

    // ---------
    // Internals
    // ---------

    // Create a post of type T
    public(friend) fun create_post_internal<T, V>(
        signer_ref: &signer,
        content: String,
        description: String
    ) {
        // Get the address of the signer
        let signer_addr = signer::address_of(signer_ref);
        // assert signer address is a user
        user::assert_user_exists(signer_addr);
        // Create the post based on visibility
        if (type_info::type_of<V>() == type_info::type_of<Public>()) {
            // based on type
            if (type_info::type_of<T>() == type_info::type_of<Audio>()) {
                // Create the post
                move_to(
                    signer_ref,
                    Post {
                        user_addr: signer_addr,
                        content: Audio { content: content },
                        description: description,
                        visibility: Public {},
                        timestamp: timestamp::now_microseconds()
                    }
                );
                move_to(signer_ref, Public {});
            }
        } else if (type_info::type_of<V>() == type_info::type_of<Private>()) {

        } else { assert!(false, 3); }
    }
}