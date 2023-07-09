// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {AdoptAHyphen} from "../src/AdoptAHyphen.sol";

/// @notice A script to print the token URI returned by `AdoptAHyphen` for
/// testing purposes.
contract PrintAdoptAHyphenScript is Script {
    /// @notice The instance of `AdoptAHyphen` that will be deployed after the
    /// script runs.
    AdoptAHyphen internal adoptAFriend;

    /// @notice Deploys an instance of `AdoptAHyphen` then mints tokens #1, ...,
    /// and #9999.
    function setUp() public {
        adoptAFriend = new AdoptAHyphen(address(0xBEEF), address(0xC0FFEE));
        for (uint256 i; i < 10000; ) {
            // adoptAFriend.mint(i);
            unchecked {
                ++i;
            }
        }
    }

    /// @notice Prints the token URIs for tokens #1 through #15.
    function run() public view {
        for (uint256 i = 1; i < 100; i++) {
            // console.log(adoptAFriend.tokenURI(i));
        }
    }
}
