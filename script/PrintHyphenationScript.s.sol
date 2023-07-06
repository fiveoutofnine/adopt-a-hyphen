// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {Hyphenation} from "../src/Hyphenation.sol";

/// @notice A script to print the token URI returned by `Hyphenation` for
/// testing purposes.
contract PrintHyphenationScript is Script {
    /// @notice The instance of `Hyphenation` that will be deployed after the
    /// script runs.
    Hyphenation internal hyphenation;

    /// @notice Deploys an instance of `Hyphenation` then mints tokens #1, ...,
    /// and #9999.
    function setUp() public {
        hyphenation = new Hyphenation(address(0xC0FFEE));
        for (uint256 i; i < 10000; ) {
            hyphenation.mint();
            unchecked {
                ++i;
            }
        }
    }

    /// @notice Prints the token URI for token #1.
    function run() public view {
        console.log(hyphenation.tokenURI(1));
    }
}
