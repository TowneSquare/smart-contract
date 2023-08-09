module townesquare_sc::townesquare_state_create_logic {
    use townesquare_sc::townesquare_state;
    use townesquare_sc::townesquare_state_created;

    friend townesquare_sc::townesquare_state_aggregate;

    public(friend) fun verify(
        account: &signer,
        is_emergency: bool,
        user_admin: address,
        post_admin: address,
    ): townesquare_state::TownesquareStateCreated {
        townesquare_sc::genesis_account::assert_genesis_account(account);
        let _ = account;
        townesquare_state::new_townesquare_state_created(
            is_emergency,
            user_admin,
            post_admin,
        )
    }

    public(friend) fun mutate(
        _account: &signer,
        townesquare_state_created: &townesquare_state::TownesquareStateCreated,
    ): townesquare_state::TownesquareState {
        let is_emergency = townesquare_state_created::is_emergency(townesquare_state_created);
        let user_admin = townesquare_state_created::user_admin(townesquare_state_created);
        let post_admin = townesquare_state_created::post_admin(townesquare_state_created);
        townesquare_state::new_townesquare_state(
            is_emergency,
            user_admin,
            post_admin,
        )
    }

}
