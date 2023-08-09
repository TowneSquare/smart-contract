module townesquare_sc::user_create_logic {
    use std::string::String;
    use townesquare_sc::user;
    use townesquare_sc::user_created;

    friend townesquare_sc::user_aggregate;

    use  townesquare_sc::townesquare_state;
    const EIS_EMERGENCY: u64 = 117;
    const EINVALID_ACCOUNT: u64 = 118;

    public(friend) fun verify(
        account: &signer,
        username: String,
        profile_image: String,
        bio: String,
    ): user::UserCreated {
        assert!(!townesquare_state::singleton_is_emergency(), EIS_EMERGENCY);
        let _ = account;
        let user_wallet = signer::address_of(account);
        user::asset_user_not_exists(user_wallet);
        user::new_user_created(
            user_wallet,
            username,
            profile_image,
            bio,
        )
    }

    public(friend) fun mutate(
        _account: &signer,
        user_created: &user::UserCreated,
    ): user::User {
        let user_wallet = user_created::user_wallet(user_created);
        let username = user_created::username(user_created);
        let profile_image = user_created::profile_image(user_created);
        let bio = user_created::bio(user_created);
        user::create_user(
            user_wallet,
            username,
            profile_image,
            bio,
        )
    }

}
