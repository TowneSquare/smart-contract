
<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post"></a>

# Module `0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0::post`



-  [Resource `PostData`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostData)
-  [Resource `PostDeleteRef`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostDeleteRef)
-  [Struct `PostMetadata`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostMetadata)
-  [Struct `PostStateGroup`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostStateGroup)
-  [Resource `PostState`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostState)
-  [Resource `Public`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_Public)
-  [Resource `Private`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_Private)
-  [Constants](#@Constants_0)
-  [Function `init`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_init)
-  [Function `create_post_internal`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_create_post_internal)
-  [Function `is_post`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post)
-  [Function `get_post_id`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_get_post_id)
-  [Function `is_post_public`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post_public)
-  [Function `is_post_private`](#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post_private)


<pre><code><b>use</b> <a href="">0x1::error</a>;
<b>use</b> <a href="">0x1::event</a>;
<b>use</b> <a href="">0x1::object</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::type_info</a>;
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostData"></a>

## Resource `PostData`



<pre><code>#[resource_group_member(#[group = <a href="_ObjectGroup">0x1::object::ObjectGroup</a>])]
<b>struct</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostData">PostData</a> <b>has</b> key
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostDeleteRef"></a>

## Resource `PostDeleteRef`



<pre><code>#[resource_group_member(#[group = <a href="_ObjectGroup">0x1::object::ObjectGroup</a>])]
<b>struct</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostDeleteRef">PostDeleteRef</a> <b>has</b> key
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostMetadata"></a>

## Struct `PostMetadata`



<pre><code>#[<a href="">event</a>]
<b>struct</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostMetadata">PostMetadata</a> <b>has</b> drop, store
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostStateGroup"></a>

## Struct `PostStateGroup`



<pre><code>#[resource_group(#[scope = module_])]
<b>struct</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostStateGroup">PostStateGroup</a>
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostState"></a>

## Resource `PostState`



<pre><code>#[resource_group_member(#[group = <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostStateGroup">0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0::post::PostStateGroup</a>])]
<b>struct</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostState">PostState</a> <b>has</b> key
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_Public"></a>

## Resource `Public`



<pre><code>#[resource_group_member(#[group = <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostStateGroup">0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0::post::PostStateGroup</a>])]
<b>struct</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_Public">Public</a> <b>has</b> key
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_Private"></a>

## Resource `Private`



<pre><code>#[resource_group_member(#[group = <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_PostStateGroup">0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0::post::PostStateGroup</a>])]
<b>struct</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_Private">Private</a> <b>has</b> key
</code></pre>



<a id="@Constants_0"></a>

## Constants


<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_ERROR_INVALID_POST_VISIBILITY"></a>

The post visibility is invalid


<pre><code><b>const</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_ERROR_INVALID_POST_VISIBILITY">ERROR_INVALID_POST_VISIBILITY</a>: u64 = 0;
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_ERROR_POST_DOES_NOT_EXIST"></a>

The post does not exist


<pre><code><b>const</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_ERROR_POST_DOES_NOT_EXIST">ERROR_POST_DOES_NOT_EXIST</a>: u64 = 1;
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_init"></a>

## Function `init`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_init">init</a>(ts: &<a href="">signer</a>)
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_create_post_internal"></a>

## Function `create_post_internal`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_create_post_internal">create_post_internal</a>&lt;Visibility&gt;(signer_ref: &<a href="">signer</a>, content: <a href="">vector</a>&lt;u8&gt;): u64
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post"></a>

## Function `is_post`



<pre><code><b>public</b> <b>fun</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post">is_post</a>&lt;T: key&gt;(obj: <a href="_Object">object::Object</a>&lt;T&gt;): bool
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_get_post_id"></a>

## Function `get_post_id`



<pre><code><b>public</b> <b>fun</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_get_post_id">get_post_id</a>&lt;T: key&gt;(obj: <a href="_Object">object::Object</a>&lt;T&gt;): u64
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post_public"></a>

## Function `is_post_public`



<pre><code><b>public</b> <b>fun</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post_public">is_post_public</a>&lt;T: key&gt;(obj: <a href="_Object">object::Object</a>&lt;T&gt;): bool
</code></pre>



<a id="0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post_private"></a>

## Function `is_post_private`



<pre><code><b>public</b> <b>fun</b> <a href="post.md#0xd9dfc03b5a835891c26a514104444c66f562ac07885e703cd412da656e41efd0_post_is_post_private">is_post_private</a>&lt;T: key&gt;(obj: <a href="_Object">object::Object</a>&lt;T&gt;): bool
</code></pre>
