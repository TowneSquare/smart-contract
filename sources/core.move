/*
    master module

    TODO:
        - description
        - add friends mechanism
        - add blacklist mechanism from transaction contract
        - implements an emergency mechanism

*/

module townesquare::core {
    // use aptos_std::big_vector;
    use aptos_std::type_info;
    use std::error;
    use std::vector;
    use std::signer;

    // Global storage for TowneSquare users
    struct Users has key, drop, store {
        personal_acc_list: vector<address>,
        creator_acc_list: vector<address>,
        moderator_acc_list: vector<address>
    }

    // Global storage for deleted users
    struct DeletedUsers has key, drop, store {
        deleted_acc_list: vector<address>
    }

    // TODO init by ts addr; that's a one time use function
    // store structs under ts addr
    fun init_module(addr_signer_ref: &signer) {
        // Assert the signer is ts address
        assert!(signer::address_of(addr_signer_ref) == @townesquare, 1);

        // Create lists and store them under ts address
        move_to(
            addr_signer_ref,
            Users {
                personal_acc_list: vector::empty<address>(),
                creator_acc_list: vector::empty<address>(),
                moderator_acc_list: vector::empty<address>()
            }
        );
    }

}