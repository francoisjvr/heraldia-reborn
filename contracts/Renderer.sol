// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ColorEngine.sol";
import "./Storage.sol";

/**
 * @title Renderer
 * @dev Responsible for generating the on-chain SVG using ColorEngine output
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

        string memory p = _toHex(primary);
        string memory s = _toHex(secondary);
        string memory b = _toHex(bg);

        // Simple but real heraldic-style SVG using the three colors
        return string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="', b, '"/>',
            // Shield shape
            '<path d="M100 60 Q200 20 300 60 L300 220 Q200 320 100 220 Z" fill="', p, '" stroke="', s, '" stroke-width="12"/>',
            // Inner charge (simple cross or circle based on hash)
            '<circle cx="200" cy="160" r="45" fill="', s, '"/>',
            '<rect x="175" y="115" width="50" height="90" fill="', p, '"/>',
            '<rect x="155" y="135" width="90" height="50" fill="', p, '"/>',
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
}