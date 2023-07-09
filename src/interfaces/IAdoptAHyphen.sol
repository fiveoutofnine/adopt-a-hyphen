// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title The interface for {AdoptAHyphen}
interface IAdoptAHyphen {
    // -------------------------------------------------------------------------
    // Errors
    // -------------------------------------------------------------------------

    /// @notice Emitted when a token has already been minted.
    error TokenMinted();

    /// @notice Emitted when a token hasn't been minted.
    error TokenUnminted();

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Mints a token to the sender in exchange for the hyphen NFT from
    /// Zora (the Zora NFT gets transferred into this contract, and it can never
    /// be transferred out).
    /// @dev `msg.sender` must have approvals set to `true` on the Zora NFT with
    /// the operator as this contract's address.
    function mint(uint256 _tokenId) external;
}
