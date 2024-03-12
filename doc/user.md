
<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user"></a>

# Module `0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81::user`



-  [Resource `User`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_User)
-  [Resource `Personal`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Personal)
-  [Resource `Creator`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Creator)
-  [Resource `Moderator`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Moderator)
-  [Resource `PostTracker`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_PostTracker)
-  [Resource `Active`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Active)
-  [Resource `Inactive`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Inactive)
-  [Struct `UserCreatedEvent`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_UserCreatedEvent)
-  [Function `create_user_internal`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_create_user_internal)
-  [Function `add_user_type_internal`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_add_user_type_internal)
-  [Function `delete_user_type_internal`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_delete_user_type_internal)
-  [Function `delete_user_internal`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_delete_user_internal)
-  [Function `assert_user_exists`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_assert_user_exists)
-  [Function `assert_user_does_not_exist`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_assert_user_does_not_exist)
-  [Function `get_username`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_username)
-  [Function `get_personal_from_address`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_from_address)
-  [Function `get_creator_from_address`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_creator_from_address)
-  [Function `get_moderator_from_address`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_moderator_from_address)
-  [Function `get_personal_username`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_username)
-  [Function `get_creator_username`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_creator_username)
-  [Function `get_moderator_username`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_moderator_username)
-  [Function `get_personal_pfp`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_pfp)
-  [Function `is_user`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_is_user)
-  [Function `is_user_of_type`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_is_user_of_type)
-  [Function `get_created_posts_total_number`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_created_posts_total_number)
-  [Function `signer_is_active`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_signer_is_active)
-  [Function `signer_is_inactive`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_signer_is_inactive)
-  [Function `address_is_active`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_address_is_active)
-  [Function `address_is_inactive`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_address_is_inactive)
-  [Function `set_username_internal`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_set_username_internal)
-  [Function `set_pfp_internal`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_set_pfp_internal)
-  [Function `change_user_type`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_user_type)
-  [Function `change_activity_status_from_inactive_to_active`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_activity_status_from_inactive_to_active)
-  [Function `change_activity_status_from_active_to_inactive`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_activity_status_from_active_to_inactive)
-  [Function `increment_post_tracker`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_increment_post_tracker)
-  [Function `decrement_post_tracker`](#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_decrement_post_tracker)


<pre><code><b>use</b> <a href="">0x1::event</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::string</a>;
<b>use</b> <a href="">0x1::type_info</a>;
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_User"></a>

## Resource `User`

Storage for user


<pre><code><b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_User">User</a> <b>has</b> key
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Personal"></a>

## Resource `Personal`

Global storage for personal user


<pre><code><b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Personal">Personal</a> <b>has</b> drop, store, key
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Creator"></a>

## Resource `Creator`

Global storage for creator user


<pre><code><b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Creator">Creator</a> <b>has</b> drop, store, key
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Moderator"></a>

## Resource `Moderator`

Global storage for moderator user


<pre><code><b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Moderator">Moderator</a> <b>has</b> drop, store, key
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_PostTracker"></a>

## Resource `PostTracker`

Post tracker;


<pre><code><b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_PostTracker">PostTracker</a> <b>has</b> key
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Active"></a>

## Resource `Active`

Activity status


<pre><code><b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Active">Active</a> <b>has</b> key
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Inactive"></a>

## Resource `Inactive`



<pre><code><b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Inactive">Inactive</a> <b>has</b> key
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_UserCreatedEvent"></a>

## Struct `UserCreatedEvent`

Event for user creation


<pre><code>#[<a href="">event</a>]
<b>struct</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_UserCreatedEvent">UserCreatedEvent</a>&lt;Type: drop, store&gt; <b>has</b> drop, store
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_create_user_internal"></a>

## Function `create_user_internal`

Create a new user


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_create_user_internal">create_user_internal</a>&lt;T: drop, store&gt;(signer_ref: &<a href="">signer</a>, pfp: <b>address</b>, username: <a href="_String">string::String</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_add_user_type_internal"></a>

## Function `add_user_type_internal`

Add type to user


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_add_user_type_internal">add_user_type_internal</a>&lt;T&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_delete_user_type_internal"></a>

## Function `delete_user_type_internal`

Delete a user type


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_delete_user_type_internal">delete_user_type_internal</a>&lt;T&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_delete_user_internal"></a>

## Function `delete_user_internal`

Delete a user alongside all its types


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_delete_user_internal">delete_user_internal</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_assert_user_exists"></a>

## Function `assert_user_exists`

assert user exists; checks if users exists under any type


<pre><code><b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_assert_user_exists">assert_user_exists</a>(addr: <b>address</b>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_assert_user_does_not_exist"></a>

## Function `assert_user_does_not_exist`

assert user does not exist; assert user address does not exist under any type


<pre><code><b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_assert_user_does_not_exist">assert_user_does_not_exist</a>(addr: <b>address</b>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_username"></a>

## Function `get_username`

returns User of type Personal


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_username">get_username</a>&lt;T&gt;(signer_ref: &<a href="">signer</a>, user_addr: <b>address</b>): <a href="_String">string::String</a>
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_from_address"></a>

## Function `get_personal_from_address`

Get user of type personal from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_from_address">get_personal_from_address</a>(maybe_user_addr: <b>address</b>): (<a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_User">user::User</a>, <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Personal">user::Personal</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_creator_from_address"></a>

## Function `get_creator_from_address`

Get user of type creator from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_creator_from_address">get_creator_from_address</a>(maybe_user_addr: <b>address</b>): (<a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_User">user::User</a>, <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Creator">user::Creator</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_moderator_from_address"></a>

## Function `get_moderator_from_address`

Get user of type moderator from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_moderator_from_address">get_moderator_from_address</a>(maybe_user_addr: <b>address</b>): (<a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_User">user::User</a>, <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_Moderator">user::Moderator</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_username"></a>

## Function `get_personal_username`

Get personal username from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_username">get_personal_username</a>(maybe_user: <b>address</b>): <a href="_String">string::String</a>
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_creator_username"></a>

## Function `get_creator_username`

Get creator username from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_creator_username">get_creator_username</a>(maybe_user: <b>address</b>): <a href="_String">string::String</a>
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_moderator_username"></a>

## Function `get_moderator_username`

Get moderator username from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_moderator_username">get_moderator_username</a>(maybe_user: <b>address</b>): <a href="_String">string::String</a>
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_pfp"></a>

## Function `get_personal_pfp`

Get personal pfp from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_personal_pfp">get_personal_pfp</a>(maybe_user: <b>address</b>): <b>address</b>
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_is_user"></a>

## Function `is_user`

verify an address is a user giving type and address; callable by anyone


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_is_user">is_user</a>(addr: <b>address</b>): bool
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_is_user_of_type"></a>

## Function `is_user_of_type`

User exists and of type T


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_is_user_of_type">is_user_of_type</a>&lt;T&gt;(maybe_user_addr: <b>address</b>): bool
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_created_posts_total_number"></a>

## Function `get_created_posts_total_number`

Returns the total number of posts created by a user; TODO: callable by anyone?


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_get_created_posts_total_number">get_created_posts_total_number</a>(user_addr: <b>address</b>): u64
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_signer_is_active"></a>

## Function `signer_is_active`

Checks if signer is active


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_signer_is_active">signer_is_active</a>(signer_ref: &<a href="">signer</a>): bool
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_signer_is_inactive"></a>

## Function `signer_is_inactive`

Checks if signer is inactive


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_signer_is_inactive">signer_is_inactive</a>(signer_ref: &<a href="">signer</a>): bool
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_address_is_active"></a>

## Function `address_is_active`

Checks if user is an active


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_address_is_active">address_is_active</a>(user_addr: <b>address</b>): bool
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_address_is_inactive"></a>

## Function `address_is_inactive`

Checks if user is inactive


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_address_is_inactive">address_is_inactive</a>(user_addr: <b>address</b>): bool
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_set_username_internal"></a>

## Function `set_username_internal`

Change username


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_set_username_internal">set_username_internal</a>&lt;T: drop, store, key&gt;(signer_ref: &<a href="">signer</a>, new_username: <a href="_String">string::String</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_set_pfp_internal"></a>

## Function `set_pfp_internal`

Change pfp


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_set_pfp_internal">set_pfp_internal</a>&lt;T: drop, store, key&gt;(signer_ref: &<a href="">signer</a>, new_pfp: <b>address</b>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_user_type"></a>

## Function `change_user_type`

Change user type from X to Y


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_user_type">change_user_type</a>&lt;X, Y&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_activity_status_from_inactive_to_active"></a>

## Function `change_activity_status_from_inactive_to_active`

Change user's activity status from Inactive to Active


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_activity_status_from_inactive_to_active">change_activity_status_from_inactive_to_active</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_activity_status_from_active_to_inactive"></a>

## Function `change_activity_status_from_active_to_inactive`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_change_activity_status_from_active_to_inactive">change_activity_status_from_active_to_inactive</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_increment_post_tracker"></a>

## Function `increment_post_tracker`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_increment_post_tracker">increment_post_tracker</a>(signer_ref: &<a href="">signer</a>): u64
</code></pre>



<a id="0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_decrement_post_tracker"></a>

## Function `decrement_post_tracker`

decrement post tracker; this will decrement the total_posts_created and return it


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x6b7c8681599cd9f305df89719b99be9ae141f009610bc5f2baea8507be99ff81_user_decrement_post_tracker">decrement_post_tracker</a>(signer_ref: &<a href="">signer</a>): u64
</code></pre>
