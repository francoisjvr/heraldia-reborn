// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Storage.sol";

/**
 * @title Minter
 * @dev Handles minting logic and static hash generation
 */
contract Minter {
    Storage public immutable storageContract;
    uint256 public totalMinted;

    constructor(address _storage) {
        storageContract = Storage(_storage);
    }

    function mint(address to) external returns (uint256 tokenId) {
        tokenId = ++totalMinted;

        bytes32 staticHash = keccak256(abi.encodePacked(
            blockhash(block.number - 1),
            to,
            tokenId,
            block.timestamp
        ));

        storageContract.setStaticHash(tokenId, staticHash);
        return tokenId;
    }
}