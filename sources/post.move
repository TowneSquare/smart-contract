/*
    Inspired from collection/nft relationship where
    nfts are all soulbound since we can't actually transfer posts ownership

    TODO: 
        - add encryption to private posts
        - create post events
*/

module townesquare::post {
    use aptos_framework::event;
    use aptos_framework::object::{Self, Object};

    use aptos_std::type_info;

    use std::error;
    use std::signer;

    friend townesquare::core;

    // ------
    // Errors
    // ------

    /// The post visibility is invalid
    const ERROR_INVALID_POST_VISIBILITY: u64 = 0;
    /// The post does not exist
    const ERROR_POST_DOES_NOT_EXIST: u64 = 1;

    // -------
    // Structs
    // -------

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    // Global storage for posts; where T is type and V is visibility
    struct PostData has key {
        user_addr: address,
        post_id: u64,
        content: vector<u8>,    // can be uri; depends on the content type   
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    // store delete ref for each post; used to delete post
    struct PostDeleteRef has key { delete_ref: object::DeleteRef }    

    #[event]
    // Global storage for posts metadata
    struct PostMetadata has drop, store { post_id: u64 }

    #[resource_group(scope = module_)]
    struct PostStateGroup {}

    #[resource_group_member(group = townesquare::post::PostStateGroup)]
    struct PostState has key { next_post_id: u64 }

    #[resource_group_member(group = townesquare::post::PostStateGroup)]
    // Post visibility
    struct Public has key {} 
    #[resource_group_member(group = townesquare::post::PostStateGroup)]
    struct Private has key {}


    // --------------
    // Init functions
    // --------------
    public(friend) fun init(ts: &signer) {
        move_to(ts, PostState { next_post_id: 0 });
    }

    // ---------
    // Internals
    // ---------

    // Create a post; returns (guid, post)
    public(friend) fun create_post_internal<Visibility>(
        signer_ref: &signer,
        content: vector<u8>,
    ): u64 acquires PostState {
        // assert type is either public or private
        assert!(type_info::type_of<Visibility>() == type_info::type_of<Public>() ||
            type_info::type_of<Visibility>() == type_info::type_of<Private>(),
            error::not_found(ERROR_INVALID_POST_VISIBILITY)
        );
        // create object
        let user_addr = signer::address_of(signer_ref);
        let constructor_ref = object::create_object(user_addr);
        // generate post id and store it under the post object
        let post_id = get_next_post_id();
        let post_metadata = PostMetadata { post_id };
        let object_signer = object::generate_signer(&constructor_ref);
        event::emit(post_metadata);
        move_to(&object_signer, PostData { user_addr, post_id, content });
        // Generate delete ref
        let delete_ref = object::generate_delete_ref(&constructor_ref);
        move_to(&object_signer, PostDeleteRef { delete_ref });
        // based on type
        if (type_info::type_of<Visibility>() == type_info::type_of<Public>()) {
            move_to(&object_signer, Public {});
        } else { 
            move_to(&object_signer, Private {}); 
        };

        post_id
    }

    // ---------
    // Accessors
    // ---------

    fun get_next_post_id(): u64 acquires PostState {
        let post_state = borrow_global_mut<PostState>(@townesquare);
        let next_post_id = post_state.next_post_id;
        post_state.next_post_id = next_post_id + 1;

        next_post_id
    }

    public fun is_post<T: key>(obj: Object<T>): bool {
        exists<PostData>(object::object_address(&obj))
    }

    // Get a post id
    public fun get_post_id<T: key>(obj: Object<T>): u64 acquires PostData {
        let post_obj_addr = object::object_address(&obj);
        assert!(
            exists<PostData>(post_obj_addr),
            error::not_found(ERROR_POST_DOES_NOT_EXIST),
        );
        borrow_global<PostData>(post_obj_addr).post_id
    }

    // Get post visibility
    public fun is_post_public<T: key>(obj: Object<T>): bool {
        let post_obj_addr = object::object_address(&obj);
        exists<Public>(post_obj_addr)
    }

    public fun is_post_private<T: key>(obj: Object<T>): bool {
        let post_obj_addr = object::object_address(&obj);
        exists<Private>(post_obj_addr)
    }

    // --------
    // Mutators
    // --------

    // TODO: change post visibility

    // ----------
    // Unit tests
    // ----------

    #[test_only]
    use std::features;
    use std::vector;

    #[test_only]
    public fun init_test(ts: &signer) {
        init(ts);
    }

    #[test(std= @0x1, ts = @townesquare, user = @0x123)]
    // post creation test
    public fun create_post_test(std: &signer, ts: &signer, user: &signer) acquires PostState {
        // auid and events
        features::change_feature_flags(std, vector[23, 26], vector[]);
        init_test(ts);
        let post_id = create_post_internal<Public>(user, vector::empty());
        assert!(post_id == 0, 1);
    }

}