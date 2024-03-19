
<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core"></a>

# Module `0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088::core`



-  [Resource `State`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_State)
-  [Resource `Data`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_Data)
-  [Constants](#@Constants_0)
-  [Function `init`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_init)
-  [Function `create_user`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_create_user)
-  [Function `add_user_type`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_add_user_type)
-  [Function `create_post`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_create_post)
-  [Function `delete_user_type`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_delete_user_type)
-  [Function `delete_user`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_delete_user)
-  [Function `change_from_personal_to_creator`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_change_from_personal_to_creator)
-  [Function `change_from_creator_to_personal`](#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_change_from_creator_to_personal)


<pre><code><b>use</b> <a href="">0x1::account</a>;
<b>use</b> <a href="">0x1::error</a>;
<b>use</b> <a href="">0x1::option</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::smart_vector</a>;
<b>use</b> <a href="">0x1::string</a>;
<b>use</b> <a href="">0x1::type_info</a>;
<b>use</b> <a href="post.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_post">0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088::post</a>;
<b>use</b> <a href="referral.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_referral">0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088::referral</a>;
<b>use</b> <a href="user.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_user">0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088::user</a>;
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_State"></a>

## Resource `State`



<pre><code><b>struct</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_State">State</a> <b>has</b> key
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_Data"></a>

## Resource `Data`

Global storage for data that needs checks with every new entry.
Only TS can initiate and write to this storage.


<pre><code><b>struct</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_Data">Data</a> <b>has</b> key
</code></pre>



<a id="@Constants_0"></a>

## Constants


<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_TS_DATA_SEED"></a>



<pre><code><b>const</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_TS_DATA_SEED">TS_DATA_SEED</a>: <a href="">vector</a>&lt;u8&gt; = [84, 111, 119, 110, 101, 115, 113, 117, 97, 114, 101, 68, 97, 116, 97, 83, 101, 101, 100];
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_init"></a>

## Function `init`



<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_init">init</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_create_user"></a>

## Function `create_user`

Create a new user


<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_create_user">create_user</a>&lt;Type&gt;(signer_ref: &<a href="">signer</a>, referral_code: <a href="_String">string::String</a>, referrer: <a href="_Option">option::Option</a>&lt;<b>address</b>&gt;, username: <a href="_String">string::String</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_add_user_type"></a>

## Function `add_user_type`

Add a user type


<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_add_user_type">add_user_type</a>&lt;Type&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_create_post"></a>

## Function `create_post`

Create a post


<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_create_post">create_post</a>&lt;Visibility&gt;(signer_ref: &<a href="">signer</a>, content: <a href="">vector</a>&lt;u8&gt;)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_delete_user_type"></a>

## Function `delete_user_type`

Delete a user given a type


<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_delete_user_type">delete_user_type</a>&lt;Type&gt;(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_delete_user"></a>

## Function `delete_user`

Delete a user; all types


<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_delete_user">delete_user</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_change_from_personal_to_creator"></a>

## Function `change_from_personal_to_creator`

Change user type from personal to creator


<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_change_from_personal_to_creator">change_from_personal_to_creator</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_change_from_creator_to_personal"></a>

## Function `change_from_creator_to_personal`

Change user type from creator to personal


<pre><code><b>public</b> entry <b>fun</b> <a href="core.md#0x80f9e1784ca31b1158e5b17025eb1e42067d5a2313ad4a4a145e14f56c6ca088_core_change_from_creator_to_personal">change_from_creator_to_personal</a>(signer_ref: &<a href="">signer</a>)
</code></pre>
