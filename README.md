# hyphenation

[**Site**](https://partyvs.party/) - [**Party**](https://www.party.app/party/0x1c409297dd82167B6be3e79D4bF0B6f7a6ff0dB4) - [**Tweet**](https://twitter.com/prtyDAO/status/1674447750182719489) - [**hyphenation**](https://hyphenation.vercel.app) / [**scotato/hyphenation**](https://github.com/scotato/hyphenation)

adopt a hyphenated friend

## Usage

This project uses [**Foundry**](https://github.com/foundry-rs/foundry) as its development/testing framework.

### Installation

First, make sure you have Foundry installed. Then, run the following commands to clone the repo and install its dependencies:

```sh
git clone https://github.com/fiveoutofnine/hyphenation.git
cd hyphenation
forge install
```

To test the metadata output, follow the instructions in [`PrintHyphenationScript`](https://github.com/fiveoutofnine/hyphenation/blob/main/script/PrintHyphenationScript.s.sol), and run the following command:

```sh
forge script script/PrintHyphenationScript.s.sol:PrintHyphenationScript -vvv
```

To preview SVG files:
```sh
node script/preview.js
```