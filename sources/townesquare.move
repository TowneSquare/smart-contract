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
    const ENOT_DELETE: u64 = 5;
    const EINVALID_ADMIN: u64 = 6;

    struct User has key {
        owner: address, // User wallet address
        username: String, // username is unique id of townesquare app
        profile_image: String // This is link of profile image of user
    }

    struct PostList has key {
        admin: address, // poser address
        posts: Table<String, Post>, // Post list which posted by poster
    }

    struct Post has store, drop, copy {
        poster: address, // poser address
        user_id: String, // user id of our database. It should be string
        post_id: String, // post id of our database. it will be used query post based on owner and id
        content: String, // encryption string of content
        is_deleted: bool, // not sure that this field is neccessary or not
    }

    struct EventHandles has key {
        event_handle: event::EventHandle<Post>,
    }

    public fun init_event_account(account: &signer) {
        assert!(signer::address_of(account) == @townesquare_event, ENOT_GENESIS_ACCOUNT);
        move_to(account, EventHandles {
            event_handle: account::new_event_handle<Post>(account),
        });
    }

    public(friend) fun emit_post_created(post_created: Post) acquires EventHandles {
        let events = borrow_global_mut<EventHandles>(@townesquare_event);
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

    public entry fun create_post_list(admin: &signer) {
        // get the signer address
        let admin_address = signer::address_of(admin);
        let post_list = PostList {
            admin: admin_address,
            posts: table::new(),
        };
        assert!(admin_address == @townesquare_post, EINVALID_ADMIN);
        move_to(admin, post_list);
    }

    public entry fun create_post(poster: &signer, user_id: String, post_id: String, content: String) acquires PostList, EventHandles {
        // get the signer address
        let poster_address = signer::address_of(poster);
        assert!(exists<PostList>(@townesquare_post), E_NOT_INITIALIZED);
        // get the PostList resource
        let post_list = borrow_global_mut<PostList>(@townesquare_post);
        let new_post = Post {
            poster: poster_address,
            user_id,
            post_id,
            content,
            is_deleted: false,
        };
        table::upsert(&mut post_list.posts, post_id, new_post);

        emit_post_created(new_post);
    }

    public entry fun delete_post(poster: &signer, post_id: String) acquires PostList, EventHandles {
        // get the signer address
        let poster_address = signer::address_of(poster);
        assert!(exists<PostList>(@townesquare_post), E_NOT_INITIALIZED);
        // get the PostList resource
        let post_list = borrow_global_mut<PostList>(@townesquare_post);
        assert!(table::contains(&post_list.posts, post_id), EPOST_DOESNT_EXIST);
        let post = table::borrow_mut(&mut post_list.posts, post_id);
        assert!(post.is_deleted == false, EPOST_IS_DELETED);
        assert!(post.poster == poster_address || poster_address == post_list.admin, ENOT_DELETE);
        post.is_deleted = true;

        emit_post_created(*post);
    } 
}
