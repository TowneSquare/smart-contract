// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module townesquare_sc::post_aggregate {
    use std::string::String;
    use townesquare_sc::post;
    use townesquare_sc::post_create_logic;
    use townesquare_sc::post_delete_logic;

    public entry fun create(
        account: &signer,
        poster: address,
        user_id: String,
        content: String,
        digest: String,
    ) {
        let post_created = post_create_logic::verify(
            account,
            poster,
            user_id,
            content,
            digest,
        );
        let post = post_create_logic::mutate(
            account,
            &post_created,
        );
        post::add_post(post);
        post::emit_post_created(post_created);
    }

    public entry fun delete(
        account: &signer,
        post_id: u128,
    ) {
        let post = post::remove_post(post_id);
        let post_deleted = post_delete_logic::verify(
            account,
            &post,
        );
        let updated_post = post_delete_logic::mutate(
            account,
            &post_deleted,
            post,
        );
        post::drop_post(updated_post);
        post::emit_post_deleted(post_deleted);
    }

}