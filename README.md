# Adopt-a-Hyphen

[**Site**](https://adopt-a-hyphen.com) - [**Party**](https://www.party.app/party/0x1c409297dd82167B6be3e79D4bF0B6f7a6ff0dB4) - [**hyphenation**](https://hyphenation.vercel.app) / [**scotato/hyphenation**](https://github.com/scotato/hyphenation)

Adopt a Hyphen: exchange an on-chain [**Adoption Ticket**](https://zora.co/collect/eth:0x73d24948fD946AE7F20EED63D7C0680eDfaF36f1) to redeem your [**hyphen**](http://adopt-a-hyphen.com/).

> With each passing day, more and more people are switching from “on-chain” to “onchain.” While this may seem like a harmless choice, thousands of innocent hyphens are losing their place in the world. No longer needed to hold “on-chain” together, these hyphens are in need of a loving place to call home. What if you could make a difference in a hyphen’s life forever?

> Introducing the Adopt-a-Hyphen program. For the next 3 days, you can adopt a hyphen and give it a new home…right in your wallet! To adopt a hyphen, simply mint an Adoption Ticket. Each Adoption Ticket can be redeemed to adopt one hyphen. As is their nature, each hyphen lives fully on-chain and is rendered in solidity as cute, generative ASCII art. Upon redeeming your Adoption Ticket, you’ll enjoy the surprise of finding out what kind of hyphen you got!

## Deployments

<table>
    <thead>
        <tr>
            <th>Chain</th>
            <th>Chain ID</th>
            <th>Contract</th>
            <th>Address</th>
            <th>Optimization runs</th>
            <th><code>solc</code> version</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="2">Mainnet</td>
            <td rowspan="2">1</td>
            <td><code><a href="https://github.com/fiveoutofnine/adopt-a-hyphen/blob/main/src/AdoptAHyphen.sol">AdoptAHyphen</a></code></td>
            <td><a href="https://etherscan.io/address/0x2010009c4842e6B6d2630A07Dd6469172affb4dc"><code>0x2010009c4842e6B6d2630A07Dd6469172affb4dc</code></a></td><td>7777777</td><td><code>v0.8.17+commit.8df45f5f</code></td>
        </tr>
        <tr>
        <td><a href="https://zora.co/collect/eth:0x73d24948fD946AE7F20EED63D7C0680eDfaF36f1"><b>Adoption Ticket</b></a></td>
            <td><code><a href="https://etherscan.io/address/0x73d24948fD946AE7F20EED63D7C0680eDfaF36f1">0x73d24948fD946AE7F20EED63D7C0680eDfaF36f1</code></td><td>5000</td><td><code>v0.8.17+commit.8df45f5f</code></td>
        </tr>
        <tr>
            <td rowspan="2">Goerli</td>
            <td rowspan="2">5</td>
            <td><code><a href="https://github.com/fiveoutofnine/adopt-a-hyphen/blob/main/src/AdoptAHyphen.sol">AdoptAHyphen</a></code></td>
            <td><code><a href="https://goerli.etherscan.io/address/0xd9e4284f2e168ca4eaca0806d0ae3fa1059be739">0xd9e4284f2e168ca4eaca0806d0ae3fa1059be739</code></td><td>7777777</td><td><code>v0.8.17+commit.8df45f5f</code></td>
        </tr>
        <tr>
        <td><code><a href="https://github.com/fiveoutofnine/adopt-a-hyphen/blob/main/src/utils/mock/MockNFT.sol">MockNFT</a></code></td>
            <td><code><a href="https://goerli.etherscan.io/address/0xaE69717d331FD2aA877CEEAd0C6617B71eff399C">0xaE69717d331FD2aA877CEEAd0C6617B71eff399C</code></td><td>0</td><td><code>v0.8.17+commit.8df45f5f</code></td>
        </tr>
    </tbody>
<table>

## Usage

This project uses [**Foundry**](https://github.com/foundry-rs/foundry) as its development/testing framework.

### Installation

First, make sure you have Foundry installed. Then, run the following commands to clone the repo and install its dependencies:

```sh
git clone https://github.com/fiveoutofnine/adopt-a-hyphen.git
cd adopt-a-hyphen
forge install
```

### Sample metadata/art generation

To test the metadata output, follow the instructions in [`PrintAdoptAHyphenScript`](https://github.com/fiveoutofnine/adopt-a-hyphen/blob/main/script/PrintAdoptAHyphenScript.s.sol) and run the following command:

```sh
forge script script/PrintAdoptAHyphenScript.s.sol:PrintAdoptAHyphenScript -vvv
```

To generate and write SVG files after running `PrintAdoptAHyphenScript` to `script/preview`, run the following command with Node `16<=`:

```sh
node script/preview.js
```

### Deploying

1. Configure the variables `HYPHEN_NFT_CONTRACT_ADDRESS` and `OWNER` inside [`print-bytecode.sh`](https://github.com/fiveoutofnine/adopt-a-hyphen/blob/main/print-bytecode.sh), which will write the bytecode with constructor arguments to `bytecode-with-constructor.txt`.

2. [Optional] Compute a `create2` salt to deploy with. Here's some basic steps to do that with [**flood-protocol/maldon**](https://github.com/floodprotocol/maldon):

```sh
git clone https://github.com/flood-protocol/maldon.git
cd maldon
cargo install --path .
maldon --pattern $PATTERN $CREATE2_FACTORY_ADDRESS $CALLER $INIT_CODE_HASH
```

3. Use a factory (e.g. [`0x0000000000FFe8B47B3e2130213B802212439497`](https://etherscan.io/address/0x0000000000ffe8b47b3e2130213b802212439497)) to deploy the bytecode to a deterministic address or just deploy the generated bytecode.

### Verifying `AdoptAHyphen`

To compute the constructor arguments, you can copy paste the last 128 characters from `bytecode-with-constructor.txt` (remember to run `print-bytecode.sh` with the correct constructor arguments set first!) or run the following command:

```sh
cast abi-encode "constructor(address,address)" $HYPHEN_NFT_CONTRACT_ADDRESS $OWNER
```

Then, to verify the contract on [**Etherscan**](https://etherscan.io), run the following command:

```sh
forge verify-contract --chain-id $CHAIN_ID --num-of-optimizations 7777777 --watch --compiler-version $COMPILER_VERSION $DEPLOY_ADDRESS src/AdoptAHyphen.sol:AdoptAHyphen --etherscan-api-key $ETHERSCAN_KEY --constructor-args $CONSTRUCTOR_ARGS
```
