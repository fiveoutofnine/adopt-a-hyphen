// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {AdoptAHyphen} from "../src/AdoptAHyphen.sol";
import {MockNFT} from "../src/utils/mock/MockNFT.sol";

/// @notice A script to print the token URI returned by `AdoptAHyphen` for
/// testing purposes.
contract PrintAdoptAHyphenScript is Script {
    /// @notice The instance of `MockNFT` that will be deployed after the
    /// script runs.
    MockNFT internal mockNFT;

    /// @notice The instance of `AdoptAHyphen` that will be deployed after the
    /// script runs.
    AdoptAHyphen internal adoptAHyphen;

    /// @notice Deploys an instance of `MockNFT`, deploys an instance of
    /// `AdoptAHyphen` then mints tokens #1, ..., and #9999 for both.
    function setUp() public {
        // Deploy contracts.
        mockNFT = new MockNFT();
        adoptAHyphen = new AdoptAHyphen(address(mockNFT), address(0xBEEF));

        // Set approval to true for all tokens for spender `0xBEEF` and operator
        // `address(adoptAHyphen)`.
        vm.prank(address(0xBEEF));
        mockNFT.setApprovalForAll(address(adoptAHyphen), true);

        // Mint tokens MockNFT #1, ..., #9999, then exchange them to mint tokens
        // AdoptAHyphen #1, ..., #9999.
        for (uint256 i = 1; i < 10000; ) {
            mockNFT.mint(address(0xBEEF), i);
            vm.prank(address(0xBEEF));
            adoptAHyphen.mint(i);
            unchecked {
                ++i;
            }
        }
    }

    /// @notice Prints the token URIs for tokens #1 through #15.
    function run() public view {
        for (uint256 i = 1; i < 15; i++) {
            console.log(adoptAHyphen.tokenURI(i));
        }
    }
}
