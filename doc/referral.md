
<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral"></a>

# Module `0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421::referral`



-  [Resource `Referral`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_Referral)
-  [Function `create_referral`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_create_referral)
-  [Function `remove_referral`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_remove_referral)
-  [Function `referral`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_referral)
-  [Function `referrer`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_referrer)
-  [Function `get_referral_code`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_get_referral_code)
-  [Function `get_referrer_address`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_get_referrer_address)
-  [Function `has_referrer`](#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_has_referrer)


<pre><code><b>use</b> <a href="">0x1::option</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::string</a>;
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_Referral"></a>

## Resource `Referral`

Referral resource


<pre><code><b>struct</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_Referral">Referral</a> <b>has</b> key
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_create_referral"></a>

## Function `create_referral`

initialize function


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_create_referral">create_referral</a>(signer_ref: &<a href="">signer</a>, <a href="">code</a>: <a href="_String">string::String</a>, referrer: <a href="_Option">option::Option</a>&lt;<b>address</b>&gt;)
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_remove_referral"></a>

## Function `remove_referral`

Remove referral


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_remove_referral">remove_referral</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_referral"></a>

## Function `referral`

get referral code


<pre><code><b>public</b> <b>fun</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral">referral</a>(<a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral">referral</a>: &<a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_Referral">referral::Referral</a>): <a href="_String">string::String</a>
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_referrer"></a>

## Function `referrer`

get referrer address


<pre><code><b>public</b> <b>fun</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_referrer">referrer</a>(<a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral">referral</a>: &<a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_Referral">referral::Referral</a>): <b>address</b>
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_get_referral_code"></a>

## Function `get_referral_code`

Get the referral code of the signer


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_get_referral_code">get_referral_code</a>(signer_ref: &<a href="">signer</a>): <a href="_String">string::String</a>
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_get_referrer_address"></a>

## Function `get_referrer_address`

Get the referrer address of the signer


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_get_referrer_address">get_referrer_address</a>(signer_ref: &<a href="">signer</a>): <b>address</b>
</code></pre>



<a id="0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_has_referrer"></a>

## Function `has_referrer`

Returns true if the signer has a referrer and the referrer address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="referral.md#0x67e06bcc1e6c7dce9e2d2181eb675a967f7b93e19dfcdc57df1e06d863c4e421_referral_has_referrer">has_referrer</a>(signer_ref: &<a href="">signer</a>): (bool, <b>address</b>)
</code></pre>
