// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC721, ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {IAdoptAHyphen} from "./interfaces/IAdoptAHyphen.sol";
import {IERC721} from "./interfaces/IERC721.sol";
import {Base64} from "./utils/Base64.sol";
import {AdoptAHyphenArt} from "./utils/AdoptAHyphenArt.sol";
import {AdoptAHyphenMetadata} from "./utils/AdoptAHyphenMetadata.sol";

/// @title AdoptAHyphen
contract AdoptAHyphen is IAdoptAHyphen, ERC721, ERC721TokenReceiver, Owned {
    /// @notice The Zora NFT contract.
    IERC721 internal constant ZORA_NFT =
        IERC721(0x73d24948fD946AE7F20EED63D7C0680eDfaF36f1);

    // -------------------------------------------------------------------------
    // Constructor + Mint
    // -------------------------------------------------------------------------

    /// @param _owner Initial owner of the contract.
    constructor(address _owner) ERC721("adopt-a-friend", "-") Owned(_owner) {}

    /// @notice Mints a token to the sender in exchange for the hyphen NFT from
    /// Zora (the Zora NFT gets transferred into this contract, and it can never
    /// be transferred out).
    /// @dev `msg.sender` must have approvals set to `true` on the Zora NFT with
    /// the operator as this contract's address.
    function mint(uint256 _tokenId) external {
        // Revert if the token has been ``burned'' (i.e. transferred into this
        // contract).
        if (ZORA_NFT.ownerOf(_tokenId) == address(this)) revert TokenMinted();

        // Transfer the Zora NFT into this contract.
        ZORA_NFT.safeTransferFrom(msg.sender, address(this), _tokenId);

        // Mint token.
        _mint(msg.sender, _tokenId);
    }

    // -------------------------------------------------------------------------
    // ERC721Metadata
    // -------------------------------------------------------------------------

    /// @inheritdoc ERC721
    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        // Revert if the token hasn't been minted.
        if (_ownerOf[_tokenId] != address(0)) revert TokenUnminted();

        // Seed to generate the art and metadata from.
        uint256 seed = uint256(keccak256(abi.encodePacked(_tokenId)));

        // Generate the metadata.
        string memory name = AdoptAHyphenMetadata.generateName(seed);
        string memory attributes = AdoptAHyphenMetadata.generateAttributes(
            seed
        );

        return
            string.concat(
                "data:application/json;base64,",
                Base64.encode(
                    abi.encodePacked(
                        '{"name":"',
                        name,
                        '","image_data":"data:image/svg+xml;base64,',
                        Base64.encode(
                            abi.encodePacked(AdoptAHyphenArt.render(seed))
                        ),
                        '","attributes":',
                        attributes,
                        "}"
                    )
                )
            );
    }
}
