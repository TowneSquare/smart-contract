/*
    Inspired from collection/nft relationship where
    nfts are all soulbound since we can't actually transfer posts ownership

    TODO: 
        - run verifications on Text Posts to make sure it's UTF8
        - add encryption to private posts
        - change creation number to id; store id instead?
*/

module townesquare::post {
    use aptos_framework::guid::{Self, ID};
    use aptos_framework::timestamp;
    use aptos_std::smart_table::{Self, SmartTable};
    use aptos_std::type_info;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String};
    use townesquare::user::{Self, User, Moderator};

    friend townesquare::core;

    // -------
    // Structs
    // -------

    // Global storage for posts; where T is type and V is visibility
    struct Post has store {
        user_addr: address,
        content: String,    // can be uri; depends on the content type
        description: String,
        // Used by guid to guarantee globally unique posts and create event streams
        id_creation_num: u64,
        timestamp: u64       
    }

    // Post visibility
    struct Public has key { table: SmartTable<ID, Post> }   // Everyone
    struct Private has key { table: SmartTable<ID, Post> }  // Neighbour nodes only

    // -------------
    // Init function
    // -------------
    
    public(friend) fun initialize_module(signer_ref: &signer) {
        // Initialize public posts table
        let public_posts = Public { table: smart_table::new<ID, Post>() };
        move_to(signer_ref, public_posts);
        
        // Initialize private posts table
        let private_posts = Private { table: smart_table::new<ID, Post>() };
        move_to(signer_ref, private_posts);
    }

    // ---------
    // Internals
    // ---------

    // Create a post; returns (guid, post)
    public(friend) fun create_post_internal<Visibility>(
        signer_ref: &signer,
        content: String,
        description: String,
        timestamp: u64
    ) acquires Public, Private {
        let user_addr = signer::address_of(signer_ref);
        user::assert_user_exists(user_addr);
        // creation number; needed for ID
        let id_creation_num = user::increment_post_tracker(signer_ref);
        // create ID
        let id = guid::create_id(user_addr, id_creation_num);
        // if public
        if (type_info::type_of<Visibility>() == type_info::type_of<Public>()) {
            // borrow public posts
            let public_posts = borrow_global_mut<Public>(user_addr); 
            smart_table::add<ID, Post>(
                &mut public_posts.table, 
                id, 
                Post {
                    user_addr: user_addr,
                    content: content,
                    description: description,
                    id_creation_num: id_creation_num,
                    timestamp: timestamp
                }
            )
        } else if (type_info::type_of<Visibility>() == type_info::type_of<Private>()){
            // borrow private posts
            let private_posts = borrow_global_mut<Private>(user_addr);
            smart_table::add<ID, Post>(
                &mut private_posts.table, 
                id, 
                Post {
                    user_addr: user_addr,
                    content: content,
                    description: description,
                    id_creation_num: id_creation_num,
                    timestamp: timestamp
                }
            )
        };

    }

    // Delete a post
    public(friend) fun delete_post_internal(
        signer_ref: &signer,
        id_creation_num: u64
    ) {
        // user_addr == signer_addr is USER
        // get post from id_creation_num
    }

    // Force delete post; callable by moderator
    public(friend) fun force_delete_post_internal(
        signer_ref: &signer,
        user_addr: address,
        id_creation_num: u64
    ) {
        // signer_addr is MODERATOR
    }

    // ---------
    // Accessors
    // ---------
  

    // --------------
    // View Functions
    // --------------

    // get post from id
    // TODO


    // #[view]
    // Returns the post associated with the user address and the id creation number

    // #[view]
    // TODO: Returns the guid of a post given [input], used for events

    // --------
    // Mutators
    // --------

    // TODO: change post visibility
}