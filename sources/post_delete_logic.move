module townesquare_sc::post_delete_logic {
    use townesquare_sc::post;

    friend townesquare_sc::post_aggregate;

    use townesquare_sc::townesquare_state;
    const EIS_EMERGENCY: u64 = 117;
    const EINVALID_ACCOUNT: u64 = 118;

    public(friend) fun verify(
        account: &signer,
        post: &post::Post,
    ): post::PostEvent {
        assert!(!townesquare_state::singleton_is_emergency(), EIS_EMERGENCY);
        assert!(townesquare_state::singleton_post_admin() == std::signer::address_of(account) || post::poster(post) == std::signer::address_of(account), EINVALID_ACCOUNT);
        let _ = account;
        post::new_post_deleted(
            post,
        )
    }

    public(friend) fun mutate(
        _account: &signer,
        post_deleted: &post::PostEvent,
        post: post::Post,
    ): post::Post {
        let post_id = post::post_id(&post);
        let _ = post_id;
        let _ = post_deleted;
        post
    }

}
