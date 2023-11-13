/*
    Inspired from collection/nft relationship where
    nfts are all soulbound since we can't actually transfer posts ownership

    TODO: 
        - add encryption to private posts
        - create post events
*/

module townesquare::post {
    use aptos_framework::guid::{Self};

    use aptos_std::from_bcs;
    use aptos_std::smart_table::{Self, SmartTable};
    use aptos_std::type_info;

    use std::bcs;
    use std::error;
    use std::hash;
    use std::signer;
    use std::string::{String};
    use std::vector;

    use townesquare::user;

    friend townesquare::core;

    // ------
    // Errors
    // ------

    // This 0x54 constant serves as a domain separation tag dedicated
    // to townesquare post addresses.
    const TOWNESQUARE_POST_ADDRESS_SCHEME: u8 = 0x54;

    // -------
    // Structs
    // -------

    // Global storage for posts; where T is type and V is visibility
    struct Post has drop, key, store {
        user_addr: address,
        content: String,    // can be uri; depends on the content type
        description: String,
        // Used by post tracker and in post address creation
        id_creation_num: u64,
        timestamp: u64       
    }

    // Post visibility
    struct Public has key { table: SmartTable<address, Post> }   // Everyone
    struct Private has key { table: SmartTable<address, Post> }  // Neighbour nodes only

    // -------------
    // Init function
    // -------------
    
    public(friend) fun init(signer_ref: &signer) {
        // Initialize public posts table
        let public_posts = Public { table: smart_table::new<address, Post>() };
        move_to(signer_ref, public_posts);
        
        // Initialize private posts table
        let private_posts = Private { table: smart_table::new<address, Post>() };
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
        id_creation_num: u64,
        timestamp: u64
    ): address acquires Public, Private {
        let user_addr = signer::address_of(signer_ref);
        let post_address = create_post_address(user_addr, id_creation_num);
        // if public
        if (type_info::type_of<Visibility>() == type_info::type_of<Public>()) {
            let public_posts = borrow_global_mut<Public>(user_addr); 
            smart_table::add<address, Post>(
                &mut public_posts.table, 
                post_address, 
                Post {
                    user_addr: user_addr,
                    content: content,
                    description: description,
                    id_creation_num: id_creation_num,
                    timestamp: timestamp
                }
            );
            return post_address
        // if private
        } else if (type_info::type_of<Visibility>() == type_info::type_of<Private>()) {
            let private_posts = borrow_global_mut<Private>(user_addr);
            smart_table::add<address, Post>(
                &mut private_posts.table, 
                post_address, 
                Post {
                    user_addr: user_addr,
                    content: content,
                    description: description,
                    id_creation_num: id_creation_num,
                    timestamp: timestamp
                }
            );
            return post_address
        };
        return @0x0
    }

    // Delete a post
    public(friend) fun delete_post_internal<Visibility>(
        signer_ref: &signer,
        post_address: address
    ) acquires Private, Public {
        let user_addr = signer::address_of(signer_ref);
        // if public
        if (type_info::type_of<Visibility>() == type_info::type_of<Public>()) {
            // borrow public posts
            let public_posts_resource = borrow_global_mut<Public>(user_addr); 
            // get K based on V

            // delete post
            smart_table::remove<address, Post>(
                &mut public_posts_resource.table, 
                post_address
            );
            user::decrement_post_tracker(signer_ref);

        // if private
        } else if (type_info::type_of<Visibility>() == type_info::type_of<Private>()){
            // borrow private posts
            let private_posts_resource = borrow_global_mut<Private>(user_addr);
            // get K based on V

            // delete post
            smart_table::remove<address, Post>(
                &mut private_posts_resource.table, 
                post_address
            );
            user::decrement_post_tracker(signer_ref);

        };
    }

    // Force delete post; callable only by moderators
    // public(friend) fun force_delete_post_internal(
    //     signer_ref: &signer,
    //     user_addr: address,
    //     id_creation_num: u64
    // ) {
    //     // signer_addr is MODERATOR
    // }

    // ------
    // Inline
    // ------

    // Create a post address
    inline fun create_post_address(
        user_addr: address,
        id_creation_num: u64
    ): address {
        let id = guid::create_id(user_addr, id_creation_num);
        let bytes = bcs::to_bytes(&id);
        vector::push_back(&mut bytes, TOWNESQUARE_POST_ADDRESS_SCHEME);
        from_bcs::to_address(hash::sha3_256(bytes))
    }

    // -------
    // Asserts
    // -------

    // post exists
    // public(friend) fun assert_post_exists(post_address: address): bool {
        
    // }


    // --------------
    // View Functions
    // --------------

    // TODO: Get post visibility

    // TODO: get all posts from user; gas heavy

    // TODO: get posts based on visibility

    // TODO: get post from id

    // --------
    // Mutators
    // --------

    // TODO: change post visibility

    // ----------
    // Unit tests
    // ----------

}