// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {LibString} from "solady/utils/LibString.sol";
import {AdoptAHyphenArt} from "./AdoptAHyphenArt.sol";

/// @title adopt-a-hyphen metadata
/// @notice A library for generating metadata for {AdoptAHyphen}.
/// @dev For this library to be correct, all `_seed` values must be consistent
/// with every function in both {AdoptAHyphenArt} and {AdoptAHyphenMetadata}.
library AdoptAHyphenMetadata {
    using LibString for string;
    using LibString for uint256;

    /// @notice Number of bits used to generate the art. We take note of this
    /// because we don't want to use the same bits to generate the metadata.
    uint256 constant BITS_USED = 47;

    /// @notice Joined list of adjectives to use when generating the name with
    /// `_` as the delimiter.
    /// @dev To read from this constant, use
    /// `LibString.split(string(ADJECTIVES), "_")`.
    bytes constant ADJECTIVES =
        "all-important_angel-faced_awe-inspiring_battle-scarred_big-boned_bird-"
        "like_black-and-white_breath-taking_bright-eyed_broad-shouldered_bull-h"
        "eaded_butter-soft_cat-eyed_cool-headed_cross-eyed_death-defying_devil-"
        "may-care_dew-fresh_dim-witted_down-to-earth_eagle-nosed_easy-going_eve"
        "r-changing_faint-hearted_feather-brained_fish-eyed_fly-by-night_free-t"
        "hinking_fun-loving_half-baked_hawk-eyed_heart-breaking_high-spirited_h"
        "oney-dipped_honey-tongued_ice-cold_ill-gotten_iron-grey_iron-willed_ke"
        "en-eyed_kind-hearted_left-handed_lion-hearted_off-the-grid_open-faced_"
        "pale-faced_razor-sharp_red-faced_rosy-cheeked_ruby-red_self-satisfied_"
        "sharp-nosed_short-sighted_silky-haired_silver-tongued_sky-blue_slow-fo"
        "oted_smooth-as-silk_smooth-talking_snake-like_snow-cold_snow-white_sof"
        "t-voiced_sour-faced_steel-blue_stiff-necked_straight-laced_strong-mind"
        "ed_sugar-sweet_thick-headed_tight-fisted_tongue-in-cheek_tough-minded_"
        "trigger-happy_velvet-voiced_water-washed_white-faced_wide-ranging_wild"
        "-haired_wishy-washy_work-weary_yellow-bellied_camera-shy_cold-as-ice_e"
        "mpty-handed_fair-weather_fire-breathing_jaw-dropping_mind-boggling_no-"
        "nonsense_rough-and-ready_slap-happy_smooth-faced_snail-paced_soul-sear"
        "ching_star-studded_tongue-tied_too-good-to-be-true_turtle-necked_diamo"
        "nd-handed";

    /// @notice Joined list of first names to use when generating the name with
    /// `_` as the delimiter.
    /// @dev To read from this constant, use
    /// `LibString.split(string(FIRST_NAMES), "_")`.
    bytes constant FIRST_NAMES =
        "james_robert_john_mike_david_will_richard_joe_tom_chris_charles_dan_ma"
        "tt_tony_mark_mary_patty_jenny_linda_liz_barb_sue_jess_sarah_karen_lisa"
        "_nancy_betty_sandra_peggy";

    /// @notice Joined list of hue names to use when generating the name with
    /// `_` as the delimiter.
    /// @dev To read from this constant, use
    /// `LibString.split(string(HUES), "_")`.
    bytes constant HUES = "red_blue_orange_teal_pink_green_purple_gray";

    /// @notice Joined list of hobbies to use when generating the name with `_`
    /// as the delimiter.
    /// @dev To read from this constant, use
    /// `LibString.split(string(HOBBIES), "_")`.
    bytes constant HOBBIES =
        "blit-mapp_terra-form_shield-build_loot-bagg_OKPC-draw_mooncat-rescu_au"
        "to-glyph_animal-color_ava-starr_party-card_chain-runn_forgotten-run_bi"
        "bo-glint";

    /// @notice Generates a Hyphen Guy name.
    /// @param _seed Seed to select traits for the Hyphen Guy.
    /// @return Hyphen Guy's name.
    function generateName(uint256 _seed) internal pure returns (string memory) {
        string[] memory adjectives = string(ADJECTIVES).split("_");
        string[] memory firstNames = string(FIRST_NAMES).split("_");

        _seed >>= BITS_USED;

        return
            string.concat(
                adjectives[_seed % 100],
                " ",
                firstNames[(_seed >> 7) % 30] // Adjectives used 7 bits
            );
    }

    /// @notice Generates a Hyphen Guy's attributes.
    /// @param _seed Seed to select traits for the Hyphen Guy.
    /// @return Hyphen Guy's attributes.
    function generateAttributes(
        uint256 _seed
    ) internal pure returns (string memory) {
        string[] memory hues = string(HUES).split("_");
        string[] memory hobbies = string(HOBBIES).split("_");

        // We directly use the value of `_seed` because we don't need further
        // randomness.
        // The bits used to determine the color value are bits [24, 27]
        // (0-indexed). See {AdoptAHyphenArt.render} for more information.
        uint256 background = (_seed >> 24) % 9;

        // The bits used to determine whether the background is in ``intensity
        // mode'' or not are bits [30, 31] (0-indexed). See
        // {AdoptAHyphenArt.render} for more information.
        bool intensityMode = ((_seed >> 30) & 3) == 0;

        // The bits used to determine the color value are bits [43, 45]
        // (0-indexed). See {AdoptAHyphenArt.render} for more information.
        uint256 color = (_seed >> 43) & 7;

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
                '[{"trait_type":"hue","value":"',
                hues[color],
                '"},',
                '{"trait_type":"vibe","value":"',
                background == 6
                    ? "\\\\"
                    : string(
                        abi.encodePacked(
                            AdoptAHyphenArt.BACKGROUNDS[background]
                        )
                    ),
                '"},{"trait_type":"demeanor","value":"',
                intensityMode ? "ex" : "in",
                'troverted"},{"trait_type":"hobby","value":"',
                hobbies[hobby],
                'ing"},{"trait_type":"rizz","value":',
                rizz.toString(),
                "}]"
            );
    }
}
