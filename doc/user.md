
<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user"></a>

# Module `0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088::user`



-  [Resource `User`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_User)
-  [Resource `Personal`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Personal)
-  [Resource `Creator`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Creator)
-  [Resource `Moderator`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Moderator)
-  [Resource `PostTracker`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_PostTracker)
-  [Resource `Active`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Active)
-  [Resource `Inactive`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Inactive)
-  [Struct `UserCreatedEvent`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_UserCreatedEvent)
-  [Constants](#@Constants_0)
-  [Function `create_user_internal`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_create_user_internal)
-  [Function `add_user_type_internal`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_add_user_type_internal)
-  [Function `delete_user_type_internal`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_delete_user_type_internal)
-  [Function `delete_user_internal`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_delete_user_internal)
-  [Function `assert_user_exists`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_assert_user_exists)
-  [Function `assert_user_does_not_exist`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_assert_user_does_not_exist)
-  [Function `get_username`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_username)
-  [Function `get_personal_from_address`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_personal_from_address)
-  [Function `get_creator_from_address`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_creator_from_address)
-  [Function `get_moderator_from_address`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_moderator_from_address)
-  [Function `get_username_from_address`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_username_from_address)
-  [Function `is_user`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_is_user)
-  [Function `is_user_of_type`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_is_user_of_type)
-  [Function `get_created_posts_total_number`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_created_posts_total_number)
-  [Function `signer_is_active`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_signer_is_active)
-  [Function `signer_is_inactive`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_signer_is_inactive)
-  [Function `address_is_active`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_address_is_active)
-  [Function `address_is_inactive`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_address_is_inactive)
-  [Function `change_user_type`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_user_type)
-  [Function `change_activity_status_from_inactive_to_active`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_activity_status_from_inactive_to_active)
-  [Function `change_activity_status_from_active_to_inactive`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_activity_status_from_active_to_inactive)
-  [Function `increment_post_tracker`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_increment_post_tracker)
-  [Function `decrement_post_tracker`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_decrement_post_tracker)


<pre><code><b>use</b> <a href="">0x1::event</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::string</a>;
<b>use</b> <a href="">0x1::type_info</a>;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_User"></a>

## Resource `User`

Storage for user


<pre><code><b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_User">User</a> <b>has</b> key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Personal"></a>

## Resource `Personal`

Global storage for personal user


<pre><code><b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Personal">Personal</a> <b>has</b> drop, store, key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Creator"></a>

## Resource `Creator`

Global storage for creator user


<pre><code><b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Creator">Creator</a> <b>has</b> drop, store, key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Moderator"></a>

## Resource `Moderator`

Global storage for moderator user


<pre><code><b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Moderator">Moderator</a> <b>has</b> drop, store, key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_PostTracker"></a>

## Resource `PostTracker`

Post tracker;


<pre><code><b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_PostTracker">PostTracker</a> <b>has</b> key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Active"></a>

## Resource `Active`

Activity status


<pre><code><b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Active">Active</a> <b>has</b> key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Inactive"></a>

## Resource `Inactive`



<pre><code><b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Inactive">Inactive</a> <b>has</b> key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_UserCreatedEvent"></a>

## Struct `UserCreatedEvent`

Event for user creation


<pre><code>#[<a href="">event</a>]
<b>struct</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_UserCreatedEvent">UserCreatedEvent</a> <b>has</b> drop, store
</code></pre>



<a id="@Constants_0"></a>

## Constants


<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EINVALID_ACCESS"></a>

The caller does not have access permission


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EINVALID_ACCESS">EINVALID_ACCESS</a>: u64 = 6;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EINVALID_USER_TYPE"></a>

The user type is invalid


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EINVALID_USER_TYPE">EINVALID_USER_TYPE</a>: u64 = 4;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EPOST_TRACKER_DOES_NOT_EXIST"></a>

The post tracker does not exist


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EPOST_TRACKER_DOES_NOT_EXIST">EPOST_TRACKER_DOES_NOT_EXIST</a>: u64 = 9;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_ETYPES_SHOULD_BE_DIFFERENT"></a>

The types should be different


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_ETYPES_SHOULD_BE_DIFFERENT">ETYPES_SHOULD_BE_DIFFERENT</a>: u64 = 7;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_ALREADY_OF_TYPE"></a>

The user is already of the inputted type


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_ALREADY_OF_TYPE">EUSER_ALREADY_OF_TYPE</a>: u64 = 3;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_DOES_NOT_EXIST"></a>

The user does not exist


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_DOES_NOT_EXIST">EUSER_DOES_NOT_EXIST</a>: u64 = 2;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_EXISTS"></a>

The user already exists


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_EXISTS">EUSER_EXISTS</a>: u64 = 1;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_HAS_NO_TYPE"></a>

The user has no type


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_HAS_NO_TYPE">EUSER_HAS_NO_TYPE</a>: u64 = 8;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_OF_TYPE_DOES_NOT_EXIST"></a>

The user has not the inputted type


<pre><code><b>const</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_EUSER_OF_TYPE_DOES_NOT_EXIST">EUSER_OF_TYPE_DOES_NOT_EXIST</a>: u64 = 5;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_create_user_internal"></a>

## Function `create_user_internal`

Create a new user


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_create_user_internal">create_user_internal</a>&lt;T: drop, store&gt;(signer_ref: &<a href="">signer</a>, username: <a href="_String">string::String</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_add_user_type_internal"></a>

## Function `add_user_type_internal`

Add type to user


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_add_user_type_internal">add_user_type_internal</a>&lt;T&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_delete_user_type_internal"></a>

## Function `delete_user_type_internal`

Delete a user type


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_delete_user_type_internal">delete_user_type_internal</a>&lt;T&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_delete_user_internal"></a>

## Function `delete_user_internal`

Delete a user alongside all its types


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_delete_user_internal">delete_user_internal</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_assert_user_exists"></a>

## Function `assert_user_exists`

assert user exists; checks if users exists under any type


<pre><code><b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_assert_user_exists">assert_user_exists</a>(addr: <b>address</b>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_assert_user_does_not_exist"></a>

## Function `assert_user_does_not_exist`

assert user does not exist; assert user address does not exist under any type


<pre><code><b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_assert_user_does_not_exist">assert_user_does_not_exist</a>(addr: <b>address</b>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_username"></a>

## Function `get_username`

returns User of type Personal


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_username">get_username</a>&lt;T&gt;(signer_ref: &<a href="">signer</a>, user_addr: <b>address</b>): <a href="_String">string::String</a>
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_personal_from_address"></a>

## Function `get_personal_from_address`

Get user of type personal from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_personal_from_address">get_personal_from_address</a>(maybe_user_addr: <b>address</b>): (<a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_User">user::User</a>, <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Personal">user::Personal</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_creator_from_address"></a>

## Function `get_creator_from_address`

Get user of type creator from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_creator_from_address">get_creator_from_address</a>(maybe_user_addr: <b>address</b>): (<a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_User">user::User</a>, <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Creator">user::Creator</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_moderator_from_address"></a>

## Function `get_moderator_from_address`

Get user of type moderator from address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_moderator_from_address">get_moderator_from_address</a>(maybe_user_addr: <b>address</b>): (<a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_User">user::User</a>, <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_Moderator">user::Moderator</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_username_from_address"></a>

## Function `get_username_from_address`

Get username


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_username_from_address">get_username_from_address</a>(user_addr: <b>address</b>): <a href="_String">string::String</a>
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_is_user"></a>

## Function `is_user`

verify an address is a user giving type and address; callable by anyone


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_is_user">is_user</a>(addr: <b>address</b>): bool
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_is_user_of_type"></a>

## Function `is_user_of_type`

User exists and of type T


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_is_user_of_type">is_user_of_type</a>&lt;T&gt;(maybe_user_addr: <b>address</b>): bool
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_created_posts_total_number"></a>

## Function `get_created_posts_total_number`

Returns the total number of posts created by a user; TODO: callable by anyone?


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_get_created_posts_total_number">get_created_posts_total_number</a>(user_addr: <b>address</b>): u64
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_signer_is_active"></a>

## Function `signer_is_active`

Checks if signer is active


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_signer_is_active">signer_is_active</a>(signer_ref: &<a href="">signer</a>): bool
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_signer_is_inactive"></a>

## Function `signer_is_inactive`

Checks if signer is inactive


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_signer_is_inactive">signer_is_inactive</a>(signer_ref: &<a href="">signer</a>): bool
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_address_is_active"></a>

## Function `address_is_active`

Checks if user is an active


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_address_is_active">address_is_active</a>(user_addr: <b>address</b>): bool
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_address_is_inactive"></a>

## Function `address_is_inactive`

Checks if user is inactive


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_address_is_inactive">address_is_inactive</a>(user_addr: <b>address</b>): bool
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_user_type"></a>

## Function `change_user_type`

Change user type from X to Y


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_user_type">change_user_type</a>&lt;X, Y&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_activity_status_from_inactive_to_active"></a>

## Function `change_activity_status_from_inactive_to_active`

Change user's activity status from Inactive to Active


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_activity_status_from_inactive_to_active">change_activity_status_from_inactive_to_active</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_activity_status_from_active_to_inactive"></a>

## Function `change_activity_status_from_active_to_inactive`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_change_activity_status_from_active_to_inactive">change_activity_status_from_active_to_inactive</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_increment_post_tracker"></a>

## Function `increment_post_tracker`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_increment_post_tracker">increment_post_tracker</a>(signer_ref: &<a href="">signer</a>): u64
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_decrement_post_tracker"></a>

## Function `decrement_post_tracker`

decrement post tracker; this will decrement the total_posts_created and return it


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user_decrement_post_tracker">decrement_post_tracker</a>(signer_ref: &<a href="">signer</a>): u64
</code></pre>
