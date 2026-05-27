// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./Storage.sol";
import "./Minter.sol";
import "./Renderer.sol";

/**
 * @title HeraldReborn
 * @dev Main NFT contract - modular architecture matching original Heraldia structure
 */
contract HeraldReborn is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;

    Storage public immutable storageContract;
    Minter public immutable minterContract;
    Renderer public immutable rendererContract;

    constructor(
        address _storage,
        address _minter,
        address _renderer
    ) ERC721("HeraldReborn", "HRB") Ownable(msg.sender) {
        storageContract = Storage(_storage);
        minterContract = Minter(_minter);
        rendererContract = Renderer(_renderer);
    }

    function mint() external {
        require(totalSupply() < MAX_SUPPLY, "Max supply reached");
        uint256 tokenId = minterContract.mint(msg.sender);
        _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        string memory svg = rendererContract.render(tokenId, ownerOf(tokenId));

        // Basic JSON wrapper (expand with real attributes later)
        return string(abi.encodePacked(
            "data:application/json;base64,",
            _base64(bytes(string(abi.encodePacked(
                '{"name":"HeraldReborn #', _toString(tokenId),
                '","image":"data:image/svg+xml;base64,', _base64(bytes(svg)),
                '"}'
            ))))
        ));
    }

    // ============ Helpers ============
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

    function _base64(bytes memory data) internal pure returns (string memory) {
        return string(data); // Replace with proper base64 in production
    }
}