// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ColorEngine
 * @dev Handles dynamic color and palette generation based on owner + static hash
 */
contract ColorEngine {
    function getColors(bytes32 staticHash, address owner) external pure returns (bytes3 primary, bytes3 secondary, bytes3 background) {
        bytes32 dynamic = keccak256(abi.encodePacked(staticHash, owner));

        primary    = bytes3(dynamic);
        secondary  = bytes3(dynamic << 24);
        background = bytes3(dynamic << 48);
    }
}