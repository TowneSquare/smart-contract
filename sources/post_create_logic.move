module townesquare_sc::post_create_logic {
    use std::string::String;
    use townesquare_sc::post;
    use townesquare_sc::post_event;

    friend townesquare_sc::post_aggregate;

    use  townesquare_sc::townesquare_state;
    const EIS_EMERGENCY: u64 = 117;
    const EINVALID_ACCOUNT: u64 = 118;

    public(friend) fun verify(
        account: &signer,
        poster: address,
        user_id: String,
        content: String,
        digest: String,
    ): post::PostEvent {
        assert!(!townesquare_state::singleton_is_emergency(), EIS_EMERGENCY);
        assert!(poster == std::signer::address_of(account), EINVALID_ACCOUNT);
        let _ = account;
        post::new_post_created(
            poster,
            user_id,
            content,
            digest,
        )
    }

    public(friend) fun mutate(
        _account: &signer,
        post_created: &post::PostEvent,
    ): post::Post {
        let poster = post_event::poster(post_created);
        let user_id = post_event::user_id(post_created);
        let content = post_event::content(post_created);
        let digest = post_event::digest(post_created);
        post::create_post(
            poster,
            user_id,
            content,
            digest,
        )
    }

}
