module townesquare_sc::user_update_logic {
    use std::string::String;
    use townesquare_sc::user;
    use townesquare_sc::user_updated;

    friend townesquare_sc::user_aggregate;

    use  townesquare_sc::townesquare_state;
    const EIS_EMERGENCY: u64 = 117;
    const EINVALID_ACCOUNT: u64 = 118;

    public(friend) fun verify(
        account: &signer,
        username: String,
        profile_image: String,
        bio: String,
        user: &user::User,
    ): user::UserUpdated {
        assert!(!townesquare_state::singleton_is_emergency(), EIS_EMERGENCY);
        assert!(user::user_wallet(user) == std::signer::address_of(account), EINVALID_ACCOUNT);
        let _ = account;
        user::new_user_updated(
            user,
            username,
            profile_image,
            bio,
        )
    }

    public(friend) fun mutate(
        _account: &signer,
        user_updated: &user::UserUpdated,
        user: user::User,
    ): user::User {
        let username = user_updated::username(user_updated);
        let profile_image = user_updated::profile_image(user_updated);
        let bio = user_updated::bio(user_updated);
        let user_wallet = user::user_wallet(&user);
        let _ = user_wallet;
        user::set_username(&mut user, username);
        user::set_profile_image(&mut user, profile_image);
        user::set_bio(&mut user, bio);
        user
    }

}
