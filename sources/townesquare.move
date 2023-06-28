module townesquare_sc::townesquare {
    use std::string::{Self, String};
    use std::signer;

    struct User has key {
        owner: address,
        username: String,
        profileImage: String
    }

    struct Post has key, store {
        owner: address,
        userId: String,
        content: String,
        postId: String,
        isDeleted: bool
    }
}