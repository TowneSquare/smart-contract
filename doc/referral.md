
<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral"></a>

# Module `0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9::referral`



-  [Resource `Referral`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_Referral)
-  [Struct `ReferralCreated`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_ReferralCreated)
-  [Function `create_referral`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_create_referral)
-  [Function `remove_referral`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_remove_referral)
-  [Function `referral`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_referral)
-  [Function `referrer`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_referrer)
-  [Function `get_referral_code`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_get_referral_code)
-  [Function `get_referrer_address`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_get_referrer_address)
-  [Function `has_referrer`](#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_has_referrer)


<pre><code><b>use</b> <a href="">0x1::event</a>;
<b>use</b> <a href="">0x1::option</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::string</a>;
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_Referral"></a>

## Resource `Referral`

Referral resource


<pre><code><b>struct</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_Referral">Referral</a> <b>has</b> key
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_ReferralCreated"></a>

## Struct `ReferralCreated`



<pre><code>#[<a href="">event</a>]
<b>struct</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_ReferralCreated">ReferralCreated</a> <b>has</b> drop, store
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_create_referral"></a>

## Function `create_referral`

initialize function


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_create_referral">create_referral</a>(signer_ref: &<a href="">signer</a>, <a href="">code</a>: <a href="_String">string::String</a>, referrer: <a href="_Option">option::Option</a>&lt;<b>address</b>&gt;)
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_remove_referral"></a>

## Function `remove_referral`

Remove referral


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_remove_referral">remove_referral</a>(signer_ref: &<a href="">signer</a>)
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_referral"></a>

## Function `referral`

get referral code


<pre><code><b>public</b> <b>fun</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral">referral</a>(<a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral">referral</a>: &<a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_Referral">referral::Referral</a>): <a href="_String">string::String</a>
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_referrer"></a>

## Function `referrer`

get referrer address


<pre><code><b>public</b> <b>fun</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_referrer">referrer</a>(<a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral">referral</a>: &<a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_Referral">referral::Referral</a>): <b>address</b>
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_get_referral_code"></a>

## Function `get_referral_code`

Get the referral code of the signer


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_get_referral_code">get_referral_code</a>(signer_ref: &<a href="">signer</a>): <a href="_String">string::String</a>
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_get_referrer_address"></a>

## Function `get_referrer_address`

Get the referrer address of the signer


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_get_referrer_address">get_referrer_address</a>(signer_ref: &<a href="">signer</a>): <b>address</b>
</code></pre>



<a id="0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_has_referrer"></a>

## Function `has_referrer`

Returns true if the signer has a referrer and the referrer address


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="referral.md#0xc2d6a2f68f1749d9ab689b3e81c9e94dbea13cb34ced94bf7e07de5479fc4ad9_referral_has_referrer">has_referrer</a>(signer_ref: &<a href="">signer</a>): (bool, <b>address</b>)
</code></pre>
