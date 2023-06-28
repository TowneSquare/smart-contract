module townesquare_sc::townesquare {
    use std::string::{Self, String};
    use std::signer;

    struct User has key {
        owner: address, // User wallet address
        username: String, // username is unique id of townesquare app
        profileImage: String // This is link of profile image of user
    }

    struct Post has key, store {
        owner: address, // Poser wallet address
        userId: String, // user id of our database. It should be string
        content: String, // encryption string of content
        postId: String, // post id of our database. it will be used query post based on owner and id
        isDeleted: bool, // not sure that this field is neccessary or not
    }
}