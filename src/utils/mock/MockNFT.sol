// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.17;

import {ERC721} from "solmate/tokens/ERC721.sol";

/// @notice A mock NFT for testing purposes.
contract MockNFT is ERC721 {
    constructor() ERC721("MockNFT", "MOCK") {}

    /// @notice Mints NFT ID `_tokenId` to `_to`.
    /// @param _to Address to mint the NFT to.
    /// @param _tokenId Token ID of the NFT to mint.
    function mint(address _to, uint256 _tokenId) public {
        _mint(_to, _tokenId);
    }

    /// @inheritdoc ERC721
    function tokenURI(uint256) public pure override returns (string memory) {
        return "NFT";
    }
}
