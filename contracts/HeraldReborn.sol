// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title HeraldReborn
 * @dev On-chain generative NFT with static + dynamic hash mechanics (inspired by Heraldia)
 * Static hash = immutable emblem seed (minted once)
 * Dynamic hash = owner-dependent visual layer (changes on every transfer)
 */
contract HeraldReborn is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public totalSupply;

    // Storage for static hashes (immutable per token)
    mapping(uint256 => bytes32) public staticHashes;

    // Events
    event Minted(uint256 indexed tokenId, bytes32 staticHash, address indexed minter);
    event Transferred(uint256 indexed tokenId, address indexed from, address indexed to, bytes32 newDynamicHash);

    constructor() ERC721("HeraldReborn", "HRB") Ownable(msg.sender) {}

    /**
     * @dev Mint a new token. Static hash is generated from block data + sender.
     */
    function mint() external {
        require(totalSupply < MAX_SUPPLY, "Max supply reached");

        uint256 tokenId = totalSupply + 1;
        totalSupply++;

        // Generate immutable static hash at mint
        bytes32 staticHash = keccak256(abi.encodePacked(
            blockhash(block.number - 1),
            msg.sender,
            tokenId,
            block.timestamp
        ));

        staticHashes[tokenId] = staticHash;

        _safeMint(msg.sender, tokenId);

        emit Minted(tokenId, staticHash, msg.sender);
    }

    /**
     * @dev Override _transfer to update dynamic state on ownership change.
     */
    function _transfer(address from, address to, uint256 tokenId) internal override {
        super._transfer(from, to, tokenId);

        bytes32 newDynamicHash = _computeDynamicHash(tokenId, to);
        emit Transferred(tokenId, from, to, newDynamicHash);
    }

    /**
     * @dev Compute dynamic hash from owner + static hash.
     */
    function _computeDynamicHash(uint256 tokenId, address owner) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(staticHashes[tokenId], owner, block.chainid));
    }

    /**
     * @dev Returns the current dynamic hash for a token (based on current owner).
     */
    function getDynamicHash(uint256 tokenId) public view returns (bytes32) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return _computeDynamicHash(tokenId, ownerOf(tokenId));
    }

    /**
     * @dev On-chain SVG generation stub.
     * Traits derived from static + dynamic hashes.
     * Replace this with full SVG logic for your art style.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");

        bytes32 staticHash = staticHashes[tokenId];
        bytes32 dynamicHash = getDynamicHash(tokenId);

        // TODO: Build real SVG using hash bytes for traits
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400">',
            '<rect width="400" height="400" fill="#', _toHex(dynamicHash[0]), '"/>',
            '<text x="200" y="200" text-anchor="middle" fill="white">Token #', _toString(tokenId), '</text>',
            '</svg>'
        ));

        return string(abi.encodePacked(
            'data:application/json;base64,',
            _base64Encode(bytes(string(abi.encodePacked(
                '{"name":"HeraldReborn #', _toString(tokenId),
                '","description":"On-chain generative heraldry. Static + dynamic hashes drive the art.",',
                '"image":"data:image/svg+xml;base64,', _base64Encode(bytes(svg)), '",',
                '"attributes":[',
                '{"trait_type":"Static Hash","value":"', _toHex(staticHash), '"},',
                '{"trait_type":"Dynamic Hash","value":"', _toHex(dynamicHash), '"}',
                ']}'
            ))))
        ));
    }

    // ============ Utility functions (minimal, replace with library if needed) ============

    function _toHex(bytes32 hash) internal pure returns (string memory) {
        return string(abi.encodePacked("0x", _toHexString(hash)));
    }

    function _toHexString(bytes32 data) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(64);
        for (uint i = 0; i < 32; i++) {
            str[i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[1+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function _base64Encode(bytes memory data) internal pure returns (string memory) {
        // Minimal base64 (for demo). Use a proper library in production.
        return string(data); // Placeholder - replace with real base64
    }
}