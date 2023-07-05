module townesquare_sc::townesquare {
    use aptos_framework::event;
    use aptos_framework::account;
    use aptos_std::table::{Self, Table};
    use std::string::{Self, String};
    use std::signer;

    // Errors
    const E_NOT_INITIALIZED: u64 = 1;
    const EPOST_DOESNT_EXIST: u64 = 2;
    const EPOST_IS_DELETED: u64 = 3;
    const ENOT_GENESIS_ACCOUNT: u64 = 4;

    struct User has key {
        owner: address, // User wallet address
        username: String, // username is unique id of townesquare app
        profile_image: String // This is link of profile image of user
    }

    struct PostList has key {
        poster: address, // poser address
        user_id: String, // user id of our database. It should be string
        posts: Table<String, Post>, // Post list which posted by poster
    }

    struct Post has store, drop, copy {
        post_id: String, // post id of our database. it will be used query post based on owner and id
        group_id: String, // group id which poster post content in group or community
        content: String, // encryption string of content
        is_deleted: bool, // not sure that this field is neccessary or not
    }

    struct Tables has key {
        event_table: Table<String, Post>,
    }

    struct EventHandles has key {
        event_handle: event::EventHandle<Post>,
    }


    public fun init_event_account(account: &signer) {
        assert!(signer::address_of(account) == @aptos_demo, ENOT_GENESIS_ACCOUNT);
        move_to(account, EventHandles {
            event_handle: account::new_event_handle<Post>(account),
        });
    }

    public(friend) fun emit_order_created(post_created: Post) acquires EventHandles {
        let events = borrow_global_mut<EventHandles>(@aptos_demo);
        event::emit_event(&mut events.event_handle, post_created);
    }

    public entry fun create_user(owner: &signer, username: String, profile_image: String) {
        // get the signer address
        let owner_address = signer::address_of(owner);
        let user_profile = User {
            owner: owner_address,
            username,
            profile_image
        };
        move_to(owner, user_profile);
    }

    public entry fun update_user(owner: &signer, username: String, profile_image: String) acquires User {
        // get the signer address
        let owner_address = signer::address_of(owner);
        assert!(exists<User>(owner_address), E_NOT_INITIALIZED);
        // get User resource
        let user = borrow_global_mut<User>(owner_address);
        // update username or profile_image
        if (username != string::utf8(b"")) {
            user.username = username;
        };
        if (profile_image != string::utf8(b"")) {
            user.profile_image = profile_image;
        };
    }

    public entry fun create_post_list(poster: &signer, user_id: String) {
        // get the signer address
        let poster_address = signer::address_of(poster);
        let post_list = PostList {
            poster: poster_address,
            user_id,
            posts: table::new(),
        };
        move_to(poster, post_list);
    }

    public entry fun create_post(poster: &signer, post_id: String, group_id: String, content: String) acquires PostList, EventHandles {
        // get the signer address
        let poster_address = signer::address_of(poster);
        assert!(exists<PostList>(poster_address), E_NOT_INITIALIZED);
        // get the PostList resource
        let post_list = borrow_global_mut<PostList>(poster_address);
        let new_post = Post {
            post_id,
            group_id,
            content,
            is_deleted: false,
        };
        table::upsert(&mut post_list.posts, post_id, new_post);

        emit_order_created(new_post);
    }

    public entry fun delete_post(poster: &signer, post_id: String) acquires PostList, EventHandles {
        // get the signer address
        let poster_address = signer::address_of(poster);
        assert!(exists<PostList>(poster_address), E_NOT_INITIALIZED);
        // get the PostList resource
        let post_list = borrow_global_mut<PostList>(poster_address);
        assert!(table::contains(&post_list.posts, post_id), EPOST_DOESNT_EXIST);
        let post = table::borrow_mut(&mut post_list.posts, post_id);
        assert!(post.is_deleted == false, EPOST_IS_DELETED);
        post.is_deleted = true;

        emit_order_created(*post);
    }
}