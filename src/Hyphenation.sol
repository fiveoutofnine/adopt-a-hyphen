// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {Base64} from "./utils/Base64.sol";
import {HyphenationArt} from "./utils/HyphenationArt.sol";
import {HyphenationMetadata} from "./utils/HyphenationMetadata.sol";

/// @title Hyphenation
contract Hyphenation is ERC721, Owned {
    /// @notice The total number of tokens.
    uint256 totalSupply;

    // -------------------------------------------------------------------------
    // Constructor + Mint
    // -------------------------------------------------------------------------

    /// @param _owner Initial owner of the contract.
    constructor(address _owner) ERC721("hyphenation", "-") Owned(_owner) {}

    /// @notice Mints a token to the sender.
    function mint() external {
        unchecked {
            _mint(msg.sender, ++totalSupply);
        }
    }

    // -------------------------------------------------------------------------
    // ERC721Metadata
    // -------------------------------------------------------------------------

    /// @inheritdoc ERC721
    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        require(_ownerOf[_tokenId] != address(0), "ERC721: TOKEN_UNMINTED");

        // Seed to generate the art and metadata from.
        uint256 seed = uint256(keccak256(abi.encodePacked(_tokenId)));

        // Generate the metadata.
        string memory name = HyphenationMetadata.generateName(seed);
        string memory attributes = HyphenationMetadata.generateAttributes(seed);

        return
            string.concat(
                "data:application/json;base64,",
                Base64.encode(
                    abi.encodePacked(
                        '{"name":"',
                        name,
                        '","image_data":"data:image/svg+xml;base64,',
                        Base64.encode(
                            abi.encodePacked(HyphenationArt.render(seed))
                        ),
                        '","attributes":',
                        attributes,
                        "}"
                    )
                )
            );
    }
}
