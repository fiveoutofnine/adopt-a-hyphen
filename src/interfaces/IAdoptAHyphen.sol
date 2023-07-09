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
}
