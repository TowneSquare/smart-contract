module townesquare_sc::townesquare_state_delete_logic {
    use townesquare_sc::townesquare_state;

    friend townesquare_sc::townesquare_state_aggregate;

    public(friend) fun verify(
        account: &signer,
        townesquare_state: &townesquare_state::TownesquareState,
    ): townesquare_state::TownesquareStateDeleted {
        townesquare_sc::genesis_account::assert_genesis_account(account);
        let _ = account;
        townesquare_state::new_townesquare_state_deleted(
            townesquare_state,
        )
    }

    public(friend) fun mutate(
        _account: &signer,
        townesquare_state_deleted: &townesquare_state::TownesquareStateDeleted,
        townesquare_state: townesquare_state::TownesquareState,
    ): townesquare_state::TownesquareState {
        let _ = townesquare_state_deleted;
        townesquare_state
    }

}
