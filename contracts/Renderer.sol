// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ColorEngine.sol";
import "./Storage.sol";

/**
 * @title Renderer
 * @dev Responsible for generating the on-chain SVG
 */
contract Renderer {
    Storage public immutable storageContract;
    ColorEngine public immutable colorEngine;

    constructor(address _storage, address _colorEngine) {
        storageContract = Storage(_storage);
        colorEngine = ColorEngine(_colorEngine);
    }

    function render(uint256 tokenId, address owner) external view returns (string memory) {
        bytes32 staticHash = storageContract.getStaticHash(tokenId);
        (bytes3 primary, bytes3 secondary, bytes3 bg) = colorEngine.getColors(staticHash, owner);

        // Placeholder SVG - replace with full heraldic SVG logic
        return string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400">',
            '<rect width="400" height="400" fill="', _toHex(bg), '"/>',
            '<text x="200" y="200" fill="', _toHex(primary), '" text-anchor="middle">Token #', _toString(tokenId), '</text>',
            '</svg>'
        ));
    }

    function _toHex(bytes3 c) internal pure returns (string memory) {
        return string(abi.encodePacked("#", _toHexString(c)));
    }

    function _toHexString(bytes3 data) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(6);
        for (uint i = 0; i < 3; i++) {
            str[i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[1+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) { digits++; temp /= 10; }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}