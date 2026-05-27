// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Storage
 * @dev Stores immutable static hashes for each token (the "soul" of the emblem)
 */
contract Storage {
    mapping(uint256 => bytes32) public staticHashes;

    function setStaticHash(uint256 tokenId, bytes32 hash) external {
        require(staticHashes[tokenId] == bytes32(0), "Hash already set");
        staticHashes[tokenId] = hash;
    }

    function getStaticHash(uint256 tokenId) external view returns (bytes32) {
        return staticHashes[tokenId];
    }
}