module townesquare_sc::townesquare_state_update_logic {
    use townesquare_sc::townesquare_state;
    use townesquare_sc::townesquare_state_updated;

    friend townesquare_sc::townesquare_state_aggregate;

    public(friend) fun verify(
        account: &signer,
        is_emergency: bool,
        user_admin: address,
        post_admin: address,
        townesquare_state: &townesquare_state::TownesquareState,
    ): townesquare_state::TownesquareStateUpdated {
        townesquare_sc::genesis_account::assert_genesis_account(account);
        let _ = account;
        townesquare_state::new_townesquare_state_updated(
            townesquare_state,
            is_emergency,
            user_admin,
            post_admin,
        )
    }

    public(friend) fun mutate(
        _account: &signer,
        townesquare_state_updated: &townesquare_state::TownesquareStateUpdated,
        townesquare_state: townesquare_state::TownesquareState,
    ): townesquare_state::TownesquareState {
        let is_emergency = townesquare_state_updated::is_emergency(townesquare_state_updated);
        let user_admin = townesquare_state_updated::user_admin(townesquare_state_updated);
        let post_admin = townesquare_state_updated::post_admin(townesquare_state_updated);
        townesquare_state::set_is_emergency(&mut townesquare_state, is_emergency);
        townesquare_state::set_user_admin(&mut townesquare_state, user_admin);
        townesquare_state::set_post_admin(&mut townesquare_state, post_admin);
        townesquare_state
    }

}
