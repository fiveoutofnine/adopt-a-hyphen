// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {LibString} from "solady/utils/LibString.sol";
import {HyphenationArt} from "./HyphenationArt.sol";

/// @title HyphenationMetadata
/// @notice A library for generating metadata for {Hyphenation}.
/// @dev For this library to be correct, all `_seed` values must be consistent
/// with every function in both {HyphenationArt} and {HyphenationMetadata}.
library HyphenationMetadata {
    using LibString for uint256;

    /// @notice Number of bits used to generate the art. We take note of this
    /// because we don't want to use the same bits to generate the metadata.
    uint256 constant BITS_USED = 47;

    /// @notice Generates a Hyphen Guy name.
    /// @param _seed Seed to select traits for the Hyphen Guy.
    /// @return Hyphen Guy's name.
    function generateName(uint256 _seed) internal pure returns (string memory) {
        string[] memory ADJECTIVES = new string[](100);
        ADJECTIVES[0] = "all-important";
        ADJECTIVES[1] = "angel-faced";
        ADJECTIVES[2] = "awe-inspiring";
        ADJECTIVES[3] = "battle-scarred";
        ADJECTIVES[4] = "big-boned";
        ADJECTIVES[5] = "bird-like";
        ADJECTIVES[6] = "black-and-white";
        ADJECTIVES[7] = "breath-taking";
        ADJECTIVES[8] = "bright-eyed";
        ADJECTIVES[9] = "broad-shouldered";
        ADJECTIVES[10] = "bull-headed";
        ADJECTIVES[11] = "butter-soft";
        ADJECTIVES[12] = "cat-eyed";
        ADJECTIVES[13] = "cool-headed";
        ADJECTIVES[14] = "cross-eyed";
        ADJECTIVES[15] = "death-defying";
        ADJECTIVES[16] = "devil-may-care";
        ADJECTIVES[17] = "dew-fresh";
        ADJECTIVES[18] = "dim-witted";
        ADJECTIVES[19] = "down-to-earth";
        ADJECTIVES[20] = "eagle-nosed";
        ADJECTIVES[21] = "easy-going";
        ADJECTIVES[22] = "ever-changing";
        ADJECTIVES[23] = "faint-hearted";
        ADJECTIVES[24] = "feather-brained";
        ADJECTIVES[25] = "fish-eyed";
        ADJECTIVES[26] = "fly-by-night";
        ADJECTIVES[27] = "free-thinking";
        ADJECTIVES[28] = "fun-loving";
        ADJECTIVES[29] = "half-baked";
        ADJECTIVES[30] = "hawk-eyed";
        ADJECTIVES[31] = "heart-breaking";
        ADJECTIVES[32] = "high-spirited";
        ADJECTIVES[33] = "honey-dipped";
        ADJECTIVES[34] = "honey-tongued";
        ADJECTIVES[35] = "ice-cold";
        ADJECTIVES[36] = "ill-gotten";
        ADJECTIVES[37] = "iron-grey";
        ADJECTIVES[38] = "iron-willed";
        ADJECTIVES[39] = "keen-eyed";
        ADJECTIVES[40] = "kind-hearted";
        ADJECTIVES[41] = "left-handed";
        ADJECTIVES[42] = "lion-hearted";
        ADJECTIVES[43] = "off-the-grid";
        ADJECTIVES[44] = "open-faced";
        ADJECTIVES[45] = "pale-faced";
        ADJECTIVES[46] = "razor-sharp";
        ADJECTIVES[47] = "red-faced";
        ADJECTIVES[48] = "rosy-cheeked";
        ADJECTIVES[49] = "ruby-red";
        ADJECTIVES[50] = "self-satisfied";
        ADJECTIVES[51] = "sharp-nosed";
        ADJECTIVES[52] = "short-sighted";
        ADJECTIVES[53] = "silky-haired";
        ADJECTIVES[54] = "silver-tongued";
        ADJECTIVES[55] = "sky-blue";
        ADJECTIVES[56] = "slow-footed";
        ADJECTIVES[57] = "smooth-as-silk";
        ADJECTIVES[58] = "smooth-talking";
        ADJECTIVES[59] = "snake-like";
        ADJECTIVES[60] = "snow-cold";
        ADJECTIVES[61] = "snow-white";
        ADJECTIVES[62] = "soft-voiced";
        ADJECTIVES[63] = "sour-faced";
        ADJECTIVES[64] = "steel-blue";
        ADJECTIVES[65] = "stiff-necked";
        ADJECTIVES[66] = "straight-laced";
        ADJECTIVES[67] = "strong-minded";
        ADJECTIVES[68] = "sugar-sweet";
        ADJECTIVES[69] = "thick-headed";
        ADJECTIVES[70] = "tight-fisted";
        ADJECTIVES[71] = "tongue-in-cheek";
        ADJECTIVES[72] = "tough-minded";
        ADJECTIVES[73] = "trigger-happy";
        ADJECTIVES[74] = "velvet-voiced";
        ADJECTIVES[75] = "water-washed";
        ADJECTIVES[76] = "white-faced";
        ADJECTIVES[77] = "wide-ranging";
        ADJECTIVES[78] = "wild-haired";
        ADJECTIVES[79] = "wishy-washy";
        ADJECTIVES[80] = "work-weary";
        ADJECTIVES[81] = "yellow-bellied";
        ADJECTIVES[82] = "camera-shy";
        ADJECTIVES[83] = "cold-as-ice";
        ADJECTIVES[84] = "empty-handed";
        ADJECTIVES[85] = "fair-weather";
        ADJECTIVES[86] = "fire-breathing";
        ADJECTIVES[87] = "jaw-dropping";
        ADJECTIVES[88] = "mind-boggling";
        ADJECTIVES[89] = "no-nonsense";
        ADJECTIVES[90] = "rough-and-ready";
        ADJECTIVES[91] = "slap-happy";
        ADJECTIVES[92] = "smooth-faced";
        ADJECTIVES[93] = "snail-paced";
        ADJECTIVES[94] = "soul-searching";
        ADJECTIVES[95] = "star-studded";
        ADJECTIVES[96] = "tongue-tied";
        ADJECTIVES[97] = "too-good-to-be-true";
        ADJECTIVES[98] = "turtle-necked";
        ADJECTIVES[99] = "diamond-handed";

        string[] memory FIRST_NAMES = new string[](100);
        FIRST_NAMES[0] = "james";
        FIRST_NAMES[1] = "robert";
        FIRST_NAMES[2] = "john";
        FIRST_NAMES[3] = "mike";
        FIRST_NAMES[4] = "david";
        FIRST_NAMES[5] = "will";
        FIRST_NAMES[6] = "richard";
        FIRST_NAMES[7] = "joe";
        FIRST_NAMES[8] = "tom";
        FIRST_NAMES[9] = "chris";
        FIRST_NAMES[10] = "charles";
        FIRST_NAMES[11] = "dan";
        FIRST_NAMES[12] = "matt";
        FIRST_NAMES[13] = "tony";
        FIRST_NAMES[14] = "mark";
        FIRST_NAMES[15] = "mary";
        FIRST_NAMES[16] = "patty";
        FIRST_NAMES[17] = "jenny";
        FIRST_NAMES[18] = "linda";
        FIRST_NAMES[19] = "liz";
        FIRST_NAMES[20] = "barb";
        FIRST_NAMES[21] = "sue";
        FIRST_NAMES[22] = "jess";
        FIRST_NAMES[23] = "sarah";
        FIRST_NAMES[24] = "karen";
        FIRST_NAMES[25] = "lisa";
        FIRST_NAMES[26] = "nancy";
        FIRST_NAMES[27] = "betty";
        FIRST_NAMES[28] = "sandra";
        FIRST_NAMES[29] = "peggy";

        _seed >>= BITS_USED;

        return
            string.concat(
                ADJECTIVES[_seed % 100],
                " ",
                FIRST_NAMES[(_seed >> 7) % 30] // Adjectives used 7 bits
            );
    }

    /// @notice Generates a Hyphen Guy's attributes.
    /// @param _seed Seed to select traits for the Hyphen Guy.
    /// @return Hyphen Guy's attributes.
    function generateAttributes(
        uint256 _seed
    ) internal pure returns (string memory) {
        string[] memory HUES = new string[](8);
        HUES[0] = "red";
        HUES[1] = "blue";
        HUES[2] = "orange";
        HUES[3] = "teal";
        HUES[4] = "pink";
        HUES[5] = "green";
        HUES[6] = "purple";
        HUES[7] = "gray";

        string[] memory HOBBIES = new string[](13);
        HOBBIES[0] = "blit-mapp";
        HOBBIES[1] = "terra-form";
        HOBBIES[2] = "shield-build";
        HOBBIES[3] = "loot-bagg";
        HOBBIES[4] = "OKPC-draw";
        HOBBIES[5] = "mooncat-rescu";
        HOBBIES[6] = "auto-glyph";
        HOBBIES[7] = "animal-color";
        HOBBIES[8] = "ava-starr";
        HOBBIES[9] = "party-card";
        HOBBIES[10] = "chain-runn";
        HOBBIES[11] = "forgotten-run";
        HOBBIES[12] = "bibo-glint";

        // We directly use the value of `_seed` because we don't need further
        // randomness.
        // The bits used to determine the color value are bits [24, 27]
        // (0-indexed). See {HyphenationArt.render} for more information.
        uint256 background = (_seed >> 24) % 9;

        // The bits used to determine whether the background is in ``intensity
        // mode'' or not are bits [30, 31] (0-indexed). See
        // {HyphenationArt.render} for more information.
        bool intensityMode = ((_seed >> 30) & 3) == 0;

        // The bits used to determine the color value are bits [43, 45]
        // (0-indexed). See {HyphenationArt.render} for more information.
        uint256 color = (_seed >> 43) & 3;

        // The art renderer uses the last `BITS_USED` bits to generate its
        // traits, and `generateName` uses 12 bits to generate the name, so we
        // shift those portions off.
        _seed >>= BITS_USED;
        _seed >>= 12;
        uint256 rizz = _seed % 101; // [0, 100] (7 bits)
        _seed >>= 7;
        uint256 hobby = _seed % 13; // 13 hobbies (4 bits)
        _seed >>= 4;

        return
            string.concat(
                '[{"name":"hue","value":"',
                HUES[color],
                '"},',
                '{"name":"vibe","value":"',
                string(
                    abi.encodePacked(HyphenationArt.BACKGROUNDS[background])
                ),
                '"},{"demeanor":"',
                intensityMode ? "ex" : "in",
                'troverted"},{"name":"hobby","value":"',
                HOBBIES[hobby],
                'ing"},{"name":"rizz","value":',
                rizz.toString(),
                "}]"
            );
    }
}
