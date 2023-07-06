// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {LibPRNG} from "solady/utils/LibPRNG.sol";
import {LibString} from "solady/utils/LibString.sol";
import {Base64} from "./Base64.sol";

/// @title HyphenationArt
/// @notice A library for generating SVGs for {Hyphenation}.
library HyphenationArt {
    using LibPRNG for LibPRNG.PRNG;
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Structs
    // -------------------------------------------------------------------------

    /// @notice The traits that make up a Hyphen Guy.
    /// @param head Head trait, a number in `[0, 3]`. Equal chances.
    /// @param eye Eye trait, a number in `[0, 16]`. Equal chances.
    /// @param hat Hat trait, a number in `[0, 14]`. 25% chance of being `0`,
    /// which indicates no hat trait. Equal chances amongst the other hats.
    /// @param arm Arm trait, a number in `[0, 4]`. Equal chances.
    /// @param body Body trait, a number in `[0, 2]`. Equal chances.
    /// @param chest Chest trait, a number in `[0, 4]`. 50% chance of being `0`,
    /// which indicates no chest trait. Equal chances amongst the other chests.
    /// @param leg Leg trait, a number in `[0, 3]`. Equal chances.
    /// @param background Background trait, a number in `[0, 8]`. Equal chances.
    /// @param chaosBg Whether the background is made up of multiple background
    /// characters, or just 1. 25% chance of being true.
    /// @param intensity Number of positions (out of 253 (`23 * 11`)) to fill
    /// with a background character, a number in `[0, 252]`. 25% chance of being
    /// `252`, which indicates no variable intensity (every empty position would
    /// be filled). Equal chances amongst the other intensities.
    struct HyphenGuy {
        uint8 head;
        uint8 eye;
        uint8 hat;
        uint8 arm;
        uint8 body;
        uint8 chest;
        uint8 leg;
        uint8 background;
        bool chaosBg;
        uint8 intensity;
    }

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Starting string for the SVG.
    string constant SVG_START =
        '<svg xmlns="http://www.w3.org/2000/svg" width="150" height="150" viewBox="0 0 150 150"><st'
        "yle>@font-face{font-family:A;src:url(data:font/woff2;utf-8;base64,d09GMgABAAAAAAv4ABAAAAAA"
        "GGQAAAuXAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGmQbgRochHYGYD9TVEFUQACBehEICptclWcLgQgAATYCJAOCDA"
        "QgBYQoByAMBxvRE1FUkhZI9pFQ3b6KeSApp0iMMYLk/3x42lbvDwPoDOEKRo+FkYQNRmNyu9BGrmIWG1yU67Xb7Zbu"
        "9kWEXkXB898f5rl/S00MM14AS2/gS0sYwAhFMGDJ8/9be7VzM4H95UlYFkH4ClXn3s7fPyez86fAH0qwwQ0QHN9Etc"
        "JVSCBSRC7CJL4sXI2rELbbUj0JE5LtEZwpUw6rCt5d8/FrXxoERQIAACMKi6AQNG8Eq7R4LYhQQYQLghOEWhCZgtAJ"
        "osjwxClApPIIPDkjhgq1Wl5jhOSudWwAEjQAHzyyy6vBC0AMHdDEWUiI+C5Mlo2gKNpD9bG1Ei/eWKg1YCEBMlepCS"
        "xohvAAIGkKSGsze7VppS3Cl6Qtg6wUGTkE9w981Z6kWQLDM9MXnLb2jUFxNjDYj+T/ovASUN0NtvdB+zDeP4Lil4mR"
        "AVQCCKEFsTyhVEaCHOU+Vil/oAgSRvdmBSfIargbz5PL5HnkgTktoeCREoL67VQiyk38TaDqAhRGFBO+trg98A8QAb"
        "6sRAjIxaqRstjmP3xYOT/+BAABXwq56vS5YY05u3hIAV4utNjDtdwbHZjl8ZyBHBPcIFhUOcFAACo9BWbqlAJED2Bb"
        "f6GINmS9EBAjJqaP1RJSPn3/OyhyQjHiaOnkK1CIEAoTSyNTlmw5I40QVhNhBK5NPICGwLMTAamER42MUFz6KGp0+7"
        "7DgQ/UjLICqFa/mhxAlW6AmsC7AQAN4EnlH55+J3gYnEu8Lysb6GX8DdgKANQWjwPA4SHjTAFyy2Ie5bNjrJsQYPKy"
        "e4wABO0BuRkVEToABAEykhsIDE9K1hAjaJ9/FQUOTSBJOpUsufIVKVGlRj0jq2aDpmxwyeMBcFJwhFYhKnkdd2TN1I"
        "XnvXqrPjm9/EN1ra7WlbpQi+DZVfPg6UYoaAEA4vRIZ2WaletfGyJcqkhqeZTSxEvA0YgVKopEtkxZ0hHJoqXIpSCW"
        "SCVJDoKUhxQAlACAWwDogTcH+EsA7gWwCwAAUIgeTtkM3vBC5RYDiIM6Ax/NiAnjFKooPS3IZj4zCs15QzpUJPIXSJ"
        "KQl6+PyFe0oAotXLs32EukfX7KaeHj438eLy86UZRH08kiRVd+cD33fm7lmVmXeJppYhrMRIzW2evk+jfYTSsrJub1"
        "H2Z2Ge4VcvANC7ucXoMVshTLYwUMj6FYciphiBSST5oosdgrbV4jPBGR0m5mS1oMdiBuZO2qWtTE2KjIIbiXzZveuM"
        "Si7xDz49xPl3XYWZOJtVhYq40xmxmjkS211FL31FFmfhgb8U2FM6HGZinVAjFJp52I2mlm7kLHbvu1xyrs1RMvc8wb"
        "N95uNMpm/tnA9BIRkbqmGFeXnC2xRXZ2w3NmC4yHlqMn2Q7nWKCbeMmMCAvRp5FxgIm49bCLpRnb7KsQf42Wtq/2mk"
        "wte9K++XSSrLazVs0sskktLha2SCFZk3Svi53W/nLH0ya8/lActbjIikkayRvaC8n2d4BxZJ2URYC6LjlsJiw2kkEy"
        "dTpuApPglinBAcIi0i91gemzEI1cYi8RYYWMi7Uyj0hDUGPCnGVGueeuSvZpOfump+Jw6HHHhCkBmZMvPUSuP7Ge9j"
        "G4t28PcjJrTy8eeHpLXzah5x+G+/gVGn/jWbd1uVX7giJk3/0Cu+klXvpBhTmO9yx19rzKnk8/EGuaDiIUCJnbCUPY"
        "jKGcgYNIDYZewkLaSRvppwYHeINoQWv77LMPnj7BzC6EPoYHn3ng1HH7G89EsMvLDgdrY+ys1UJG0fAiYDvZDrZtx/"
        "Yexxu7MYFhAypy4CIspopB63XgxzzG5cKUuv/WLfLZLXHvLt64iB7Z9r0rL754aGWX/Xq9fhO/bUFckV+mLi6e2bBB"
        "N1OQllcoKV7gN1fdsqECWu7+vOfz7ufuVz+vhnbp8auPL5Wa94wqmd1dUrrear1syqpSaaqy2g3nRcHWsvU3lOAG7v"
        "5+/RKyuKgb5uSsvmT/ohyNsj2H2rV7DsndJ0rbJLSl+PJA/wdLM0sf9CPu5M2Xtj/d8xdTLWeq+/+6dnn7ws3PNL1z"
        "fY3md9Aoa7i1Xj/fuVZ/HxQ3NN5SX7y2Uz8fbtidX2y/7roika8rAYK3A9XOhCNFD3U9tUN+wvnU+SO5O9Mfs57eKd"
        "9pP43GXvj3H5EP7FwMtHMnXVcO5D2Yf0rU00kntzhj01TK9K+OLPLt+g3XF9kc7sKySaPF4W5VHjLJDUsKtPj+5vtS"
        "jFXuXuKQeCMXGc3doDZA47K1fdLptNbDOSzrglrU6pagwCEbGnKovzhjUJ8LT8zdlVGRvcrnI5FEnnEHXdvSUFPrWF"
        "2mrSirChiNDv7fVQDB2xv/3nHeHLe8LgeNbHF5eXGJ4mX3BB8ed7/f/Y1y3d+ZWX/rtIW5WZnFtfBs4sYPfatr6dMP"
        "Obvu6lJ0InJvxsj/NJnHvukJrcS5ULIYSviOooSEKnRHCwRGc96vcdsLe+uh5sajpftKM+6at4BCZvA7+PcCHgZ/yY"
        "DnWkCsTDMdO/DyI48Awbn33Si/vL35v5Mnm/+/vO1yGIIlTVVsa/5/wX+Xt2/eV/MZoPgl0cSrS1eGySrjCvTGan+f"
        "RWsNvzxTtb5WhWLm9Mbj5N99x6nTG2YU9GCYujzD38y66FPtpzcWYnN9mLIuDfRricE8cnpjvqo8k/mXFMTJKkPp/H"
        "aria51CWWYTK8o1Bur/W4/J0N9DxuOU4iVnd3xmOaxHePdECydtf44+d+A9DHD4yGn5jDy1ODW8bqPDx+u/3j7+OBt"
        "922787P96TH2guKi2TvvLJotLrDHlOhKdW0d589d7r6/M8Ir56a8TZqRkIGa2v6QkP7amgGs8i3uysptytfF2nTF+v"
        "Sq+CcdYf4VMrk9UOL6bt8a4TNBC2Pfvx2h09ialIU6W6rSmKuJrJ0pTi1OWMeP8UuL9FfXFaqmhau3eTUU7ukYcxdB"
        "lrdtfhui2r+c+/KBkgtHUpWuuBDjr12SHp9R91pD+cgN+Q7HjbrKcXrN2Yc+VGl2BTJ/e6JOQ9mIW2e33ZCt76drIO"
        "a++25ffh1w4n0z+2Dbss9rn3CVCaNecuzsLjnUPBbytAi9EkvgOY+Ah1+L1XeuHPeRzReNC53Woap5nnxeGULJj4vF"
        "r2Lx4j1+hgsj+Cb3zZvd51KNzc1G7axpYsZ2a+akv8hkv0jN5queGGPE6sAE9BY23dJX7T8wN+D12IwdwuG3EAgRCP"
        "zPbbKCeHAgQCDmkQcheFUFQgEI02RYAEbmybLr51iJDMBvM+RtM6Ci40gjrZyiIM1WwMM0rjKZlmexnFfQFSK05MkF"
        "NvSkFCTfABzw/NaCySUsAdSiwYt7B2TB5xCnw0tyyJgL7EWCc/A4rHh+zRdtCiJEyIIiqNvwVZGRUDvJaadSt3lepC"
        "jc8EOdOUBZeAbHmnugXmB3iWqjnDAoan3UBxCJYCoEe75KKv5pRSAAAo9rtno3S7W/efF4XwLwzhc/bAaADz69acjz"
        "wv8vPD5tBiBAAQACvz32gvoNOH/GSUCkQUm7H9oCflBlaZGEG5CFEBt5QDribBOFFkU4gKXRXryMJgfArhT2I7Thsa"
        "0D7QpVgPPoxRbU2ncBnfgXYSwlQuTDcyWwDzcgSscM8ZeA56vz5SKAEnWE0OvDZHm/cf3ZU4euN4AFwCwlki0spUi8"
        "uZSn0OfD6fBSvuAolggkprABAUTpgaUETCaWesM3bi2Ch78XJQYNmTbCqUu3MRyV9CLBMTrorFmr1YgxTLUaWOvBw8"
        "qDOAYj5T06tcsSRcZBd7t1R4zixMcjo4dI21xp0nRxBn/3uDap2g3ql6bTBKc+/a3oUa/t34w3oQeJMlM+jNy82KA+"
        "HVbr1GVcH79cKVV6FuSpU28mK5MXS802lgKzHItxhodxarDksKiHly4LnTqM9cExdQ+bfAj+oD48AADPLioAkda+TD"
        "w3f9F3AAAAAA==)}text{font-family:A;font-size:8px;text-anchor:left;letter-spacing:0.236364p"
        "x;dominant-baseline:central;white-space:pre;line-height:12.6px}.a{fill:";

    /// @notice Ending string for the SVG.
    string constant SVG_END = "</text></svg>";

    /// @notice Characters corresponding to the `head` trait's left characters.
    bytes32 constant HEADS_LEFT = "|[({";

    /// @notice Characters corresponding to the `head` trait's right characters.
    bytes32 constant HEADS_RIGHT = "|]})";

    /// @notice Characters corresponding to the `eye` trait's characters.
    bytes32 constant EYES = "\"#$'*+-.0=OTX^oxz";

    /// @notice Characters corresponding to the `hat` trait's characters.
    /// @dev An index of 0 corresponds to no hat trait, so the character at
    /// index 0 can be anything, but we just made it a space here.
    bytes32 constant HATS = " !#$%&'*+-.=@^~";

    /// @notice Characters corresponding to the `arm` trait's left characters.
    bytes32 constant ARMS_LEFT = "/<~J2";

    /// @notice Characters corresponding to the `arm` trait's right characters.
    bytes32 constant ARMS_RIGHT = "\\>~L7";

    /// @notice Characters corresponding to the `body` trait's left characters.
    bytes32 constant BODIES_LEFT = "[({";

    /// @notice Characters corresponding to the `body` trait's right characters.
    bytes32 constant BODIES_RIGHT = "])}";

    /// @notice Characters corresponding to the `chest` trait's characters.
    /// @dev An index of 0 corresponds to no chest trait, so the character at
    /// index 0 can be anything, but we just made it a space here.
    bytes32 constant CHESTS = "  :*=.";

    /// @notice Characters corresponding to the `leg` trait's left characters.
    bytes32 constant LEGS_LEFT = "|/|/";

    /// @notice Characters corresponding to the `leg` trait's right characters.
    bytes32 constant LEGS_RIGHT = "||\\\\";

    /// @notice Characters corresponding to the `background` trait's characters.
    bytes32 constant BACKGROUNDS = "#*+-/=\\|.";

    /// @notice Characters for the last few characters in the background that
    /// spell out ``CHAIN''.
    /// @dev The character at index 0 can be anything, but we just made it `N`
    /// here.
    bytes32 constant CHAIN_REVERSED = "NIAHC";

    // -------------------------------------------------------------------------
    // `render`
    // -------------------------------------------------------------------------

    /// @notice Renders a Hyphen Guy SVG.
    /// @param _seed Seed to select traits for the Hyphen Guy.
    /// @return SVG string representing the Hyphen Guy.
    function render(uint256 _seed) internal pure returns (string memory) {
        // Initialize PRNG.
        LibPRNG.PRNG memory prng = LibPRNG.PRNG(_seed);

        // THe Hyphen Guy.
        HyphenGuy memory hyphenGuy;

        // Select traits from `prng`.
        hyphenGuy.head = uint8(prng.state & 3); // 4 heads (2 bits)
        prng.state >>= 2;
        hyphenGuy.eye = uint8(prng.state % 17); // 17 eyes (5 bits)
        prng.state >>= 5;
        hyphenGuy.hat = uint8( // 25% chance + 14 hats (2 + 4 = 6 bits)
            prng.state & 3 == 0 ? 0 : 1 + ((prng.state >> 2) % 14)
        );
        prng.state >>= 6;
        hyphenGuy.arm = uint8(prng.state % 5); // 5 arms (3 bits)
        prng.state >>= 3;
        hyphenGuy.body = uint8(prng.state % 3); // 3 bodies (2 bits)
        prng.state >>= 2;
        hyphenGuy.chest = uint8(prng.state & 1 == 0 ? 0 : 1 + (prng.state % 5)); // 50% chance + 5 chests (1 + 3 = 4 bits)
        prng.state >>= 4;
        hyphenGuy.leg = uint8(prng.state & 3); // 4 legs (2 bits)
        prng.state >>= 2;
        hyphenGuy.background = uint8(prng.state % 9); // 9 backgrounds (4 bits)
        prng.state >>= 4;
        hyphenGuy.chaosBg = prng.state & 3 == 0; // 25% chance (2 bits)
        prng.state >>= 2;
        hyphenGuy.intensity = uint8(
            prng.state & 3 == 0 ? 252 : prng.state % 253
        ); // 25% chance + 253 intensities (2 + 8 = 10 bits)

        // Get the next state in the PRNG.
        prng.state = prng.next();

        // `bitmap` has `0`s where the index corresponds to a Hyphen Guy
        // character, and `1` where not. We use this to determine whether to
        // render a Hyphen Guy` character or a background character.
        uint256 bitmap = 0x1FFFFFFFFFFFFFFFFFFFEFFFFF07FFFE4FFFFC9FFFFFFFFFFFFFFFFFFFFFFFFF;
        uint8 chest = hyphenGuy.chest;
        assembly {
            // Equivalent to `bitmap ^= ((chest != 0) << 126)`. We flip the bit
            // corresponding to the position of the chest if there exists a
            // chest trait because we don't want to draw both a background
            // character and the chest character.
            bitmap := xor(bitmap, shl(126, gt(chest, 0)))
        }

        // Here, we initialize another bitmap to determine whether to render a
        // space character or a background character when we're not observing a
        // `hyphenGuy` character position. Since we want to render as many
        // characters in the background as equals the intensity value, we can:
        //     1. Instantiate a 253-bit long bitmap.
        //     2. Set the first `intensity` bits to `1`, and `0` otherwise.
        //     3. Shuffle the bitmap.
        // Then, by reading the bits at each index, we can determine whether to
        // render a space character (i.e. empty) or a background character. We
        // begin by instantiating an array of 253 `uint256`s, each with a single
        // `1` bit set to make use of `LibPRNG.shuffle`.
        uint256[] memory bgBitmapBits = new uint256[](253);
        for (uint256 i; i < hyphenGuy.intensity; ) {
            bgBitmapBits[i] = 1;
            unchecked {
                ++i;
            }
        }

        // Shuffle the array.
        prng.shuffle(bgBitmapBits);
        // We set `bgBitmap` to `4` (`0b100`), to ensure the bits are set
        // correctly, even if the first few read from `bgBitmapBits` are `0`.
        // Note that we can safely use `4` as a value because 253 bits offer us
        // a 3-bit leeway. Additionally, first 3 bits (from `4`) will never be
        // read because the index only goes as high as 252.
        uint256 bgBitmap = 4;
        for (uint256 i; i < 253; ) {
            // `intensity >= 252` implies `intenseBg = true`
            bgBitmap |= bgBitmapBits[i];
            bgBitmap <<= 1;
            unchecked {
                ++i;
            }
        }
        prng.state = prng.next();

        uint256 row;
        uint256 col;
        // The string corresponding to the characters of the contents of the
        // background `<text>` element.
        string memory bgStr = "";
        // The string corresponding to the characters of the contents of the
        // Hyphen Guy `<text>` element. We start with 2 spaces because of the
        // required padding to position the first row of Hyphen Guy characters.
        string memory charStr = "  ";
        // Iterate through the positions in reverse order. Note that the last
        // character (i.e. the one that contains ``N'' from ``CHAIN'') is not
        // drawn, and it must be accounted for after the loop.
        for (uint256 i = 252; i != 0; ) {
            assembly {
                row := div(i, 11)
                col := mod(i, 23)
            }

            // Add word characters (i.e. ``ON'' and ``CHAIN'').
            if (i == 252) bgStr = string.concat(bgStr, "O");
            else if (i == 251) bgStr = string.concat(bgStr, "N");
            else if (i < 5) {
                bgStr = string.concat(
                    bgStr,
                    string(abi.encodePacked(CHAIN_REVERSED[i]))
                );
            } else if ((bitmap >> i) & 1 == 0) {
                // Is a Hyphen Guy character.
                // Since there's a Hyphen Guy character that'll be drawn, the
                // background character in the same position must be empty.
                bgStr = string.concat(bgStr, " ");

                // Generate the Hyphen Guy by drawing rows of characters. Note
                // that we've already passed the check for whether a chest
                // character exists and applied it to the bitmap accordingly, so
                // we can safely draw the chest character here--if no chest
                // piece exists, a background character will be drawn anyway
                // because it wouldn't pass the `(bitmap >> i) & 1 == 0` check.
                if (i == 172) {
                    charStr = string.concat(
                        charStr,
                        string(abi.encodePacked(HATS[hyphenGuy.hat])),
                        hyphenGuy.hat != 0 ? "" : " ",
                        "  \n"
                    );
                } else if (i == 151) {
                    charStr = string.concat(
                        charStr,
                        string(abi.encodePacked(HEADS_LEFT[hyphenGuy.head])),
                        string(abi.encodePacked(EYES[hyphenGuy.eye])),
                        "-",
                        string(abi.encodePacked(EYES[hyphenGuy.eye])),
                        string(abi.encodePacked(HEADS_RIGHT[hyphenGuy.head])),
                        "\n"
                    );
                } else if (i == 128) {
                    charStr = string.concat(
                        charStr,
                        string(abi.encodePacked(ARMS_LEFT[hyphenGuy.arm])),
                        string(abi.encodePacked(BODIES_LEFT[hyphenGuy.body]))
                    );
                    {
                        charStr = string.concat(
                            charStr,
                            string(abi.encodePacked(CHESTS[hyphenGuy.chest])),
                            string(
                                abi.encodePacked(BODIES_RIGHT[hyphenGuy.body])
                            ),
                            string(abi.encodePacked(ARMS_RIGHT[hyphenGuy.arm])),
                            "\n"
                        );
                    }
                } else if (i == 105) {
                    charStr = string.concat(
                        charStr,
                        "_",
                        string(abi.encodePacked(LEGS_LEFT[hyphenGuy.leg])),
                        " ",
                        string(abi.encodePacked(LEGS_RIGHT[hyphenGuy.leg])),
                        "_"
                    );
                }
            } else if ((bgBitmap >> i) & 1 == 0) {
                // We make use of the `bgBitmap` generated earlier from the
                // intensity value here. If the check above passed, it means a
                // background character must be drawn here.
                bgStr = string.concat(
                    bgStr,
                    string(
                        abi.encodePacked(
                            BACKGROUNDS[
                                // Select a random background if `chaosBg` is
                                // true.
                                hyphenGuy.chaosBg
                                    ? prng.state % BACKGROUNDS.length
                                    : hyphenGuy.background
                            ]
                        )
                    )
                );
                // We need to generate a new random number for the next
                // potentially-random character.
                prng.state = prng.next();
            } else {
                // Failed all checks. Empty background character.
                bgStr = string.concat(bgStr, " ");
            }

            // Draw a newline character if we've reached the end of a row.
            if (col == 0) bgStr = string.concat(bgStr, "\n");
            unchecked {
                --i;
            }
        }

        return
            string.concat(
                "data:image/svg+xml;base64,",
                Base64.encode(
                    abi.encodePacked(
                        string.concat(
                            SVG_START,
                            "rgba(0,0,0,0.05)", // Background text color.
                            "}.b{fill:",
                            "#AD43ED", // Hyphen Guy color.
                            '}</style><rect width="150" height="150" rx="6" fill="',
                            "white", // Background color
                            '"/><text class="a" x="8" y="12">',
                            bgStr,
                            // Recall that ``N'' was not accounted for in the
                            // loop because we didn't look at index 0, so we
                            // draw it here.
                            'N</text><text class="b" x="60.527" y="49.8">',
                            charStr,
                            SVG_END
                        )
                    )
                )
            );
    }
}
