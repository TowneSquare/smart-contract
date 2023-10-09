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
    struct Post<T, V> has key {
        user_addr: address,
        content: T,
        description: String,
        // Used by guid to guarantee globally unique posts and create event streams
        guid_creation_num: u64,
        visibility: V,  // Public or Private
        timestamp: u64       
    }

    // Post types
    struct Audio has drop, store, key { content: String }    // uri
    struct Image has drop, store, key { content: String }    // uri
    struct Text has drop, store, key { content: String }
    struct Video has drop, store, key { content: String }    // uri

    // Post visibility
    struct Public has drop, store, key {}   // Everyone
    struct Private has drop, store, key {}  // Neighbour nodes only

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
        // post is public
        if (type_info::type_of<V>() == type_info::type_of<Public>()) {
            // type is audio
            if (type_info::type_of<T>() == type_info::type_of<Audio>()) {
                create_public_post_internal<Audio>(signer_ref, content, description);
            // type is image
            } else if (type_info::type_of<T>() == type_info::type_of<Image>()) {
                create_public_post_internal<Image>(signer_ref, content, description);
            // type is text
            } else if (type_info::type_of<T>() == type_info::type_of<Text>()) {
                create_public_post_internal<Text>(signer_ref, content, description);
            // type is video
            } else if (type_info::type_of<T>() == type_info::type_of<Video>()) {
                create_public_post_internal<Video>(signer_ref, content, description);
            } else { assert!(false, 1); }
            
        // post is private
        } else if (type_info::type_of<V>() == type_info::type_of<Private>()) {
            // type is audio
            if (type_info::type_of<T>() == type_info::type_of<Audio>()) {
                create_private_post_internal<Audio>(signer_ref, content, description);
            // type is image
            } else if (type_info::type_of<T>() == type_info::type_of<Image>()) {
                create_private_post_internal<Image>(signer_ref, content, description);
            // type is text
            } else if (type_info::type_of<T>() == type_info::type_of<Text>()) {
                create_private_post_internal<Text>(signer_ref, content, description);
            // type is video
            } else if (type_info::type_of<T>() == type_info::type_of<Video>()) {
                create_private_post_internal<Video>(signer_ref, content, description);
            } else { assert!(false, 2); }
        } else { assert!(false, 3); }
    }

    // Helper function for public posts
    inline fun create_public_post_internal<T>(
        signer_ref: &signer,
        content: String,
        description: String
    ){
        let signer_addr = signer::address_of(signer_ref);
        // update post tracker and return the creation number for guid
        let guid_creation_num = user::update_post_tracker(signer_ref);
        if (type_info::type_of<T>() == type_info::type_of<Audio>()) {
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Audio { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Public {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Public {});
        } else if (type_info::type_of<T>() == type_info::type_of<Image>()) {
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Image { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Public {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Public {});
        } else if (type_info::type_of<T>() == type_info::type_of<Text>()) {
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Text { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Public {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Public {});
        } else if (type_info::type_of<T>() == type_info::type_of<Video>()) { 
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Video { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Public {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Public {});
        }
    }

    // Helper function for private posts
    inline fun create_private_post_internal<T>(
        signer_ref: &signer,
        content: String,
        description: String
    ){
        let signer_addr = signer::address_of(signer_ref);
        // update post tracker and return the creation number for guid
        let guid_creation_num = user::update_post_tracker(signer_ref);
        if (type_info::type_of<T>() == type_info::type_of<Audio>()) {
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Audio { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Private {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Private {});
        } else if (type_info::type_of<T>() == type_info::type_of<Image>()) {
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Image { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Private {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Private {});
        } else if (type_info::type_of<T>() == type_info::type_of<Text>()) {
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Text { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Private {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Private {});
        } else if (type_info::type_of<T>() == type_info::type_of<Video>()) { 
            move_to(
            signer_ref,
            Post {
                user_addr: signer_addr,
                content: Video { content: content },
                description: description,
                guid_creation_num: guid_creation_num,
                visibility: Private {},
                timestamp: timestamp::now_microseconds()
            }
            );
            move_to(signer_ref, Private {});
        }
    }

    // ---------
    // Accessors
    // ---------
    
    // for getters
    inline fun authorized_borrow<T: key>(signer_ref: &signer): &T {
        let signer_addr = signer::address_of(signer_ref);
        assert!(exists<T>(signer_addr), 1);
        borrow_global<T>(signer_addr)
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
    // TODO: Returns the guid of a post given [input], used for events

    // --------
    // Mutators
    // --------
}