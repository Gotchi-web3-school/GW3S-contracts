// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721RewardLevel is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    struct Svg {
        address front;
        address back;
        address left;
        address right;
    }

    struct Metadatas {
        Svg svg;
        uint256 levelId;
        string type_;
        string title;
        string text;
    }

    Counters.Counter private _levelIdCounter;
    Metadatas public metadatas;

    constructor(
        string memory name, 
        string memory ticker, 
        uint256 levelId,
        string memory type_,
        string memory title,
        string memory text
        ) ERC721(name, ticker) {
        metadatas.levelId = levelId; 
        metadatas.type_ = type_; 
        metadatas.title = title; 
        metadatas.text = text; 
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _levelIdCounter.current();
        _safeMint(to, tokenId);
        _levelIdCounter.increment();
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setSvg(address front, address back, address left, address right) public {
        require(
            metadatas.svg.front == address(0) &&
            metadatas.svg.back == address(0) && 
            metadatas.svg.left == address(0) &&
            metadatas.svg.right == address(0), "setSvg: svgs already set"
        );

        metadatas.svg.front = front;
        metadatas.svg.back = back;
        metadatas.svg.left = left;
        metadatas.svg.right = right;
    }

    function getSvg() public view returns(string memory _svgFront, string memory _svgBack, string memory _svgLeft, string memory _svgRight) {
        bytes memory svgFrontByteCode = metadatas.svg.front.code;
        bytes memory svgBackByteCode = metadatas.svg.back.code;
        bytes memory svgLeftByteCode = metadatas.svg.left.code;
        bytes memory svgRightByteCode = metadatas.svg.right.code;
        _svgFront = string(abi.encodePacked(svgFrontByteCode));
        _svgBack = string(abi.encodePacked(svgBackByteCode));
        _svgLeft = string(abi.encodePacked(svgLeftByteCode));
        _svgRight = string(abi.encodePacked(svgRightByteCode));
    }

    function getMetadatas() public view returns(
        address front,
        address back,
        address left,
        address right,
        uint256 levelId,
        string memory type_,
        string memory title,
        string memory text) {
        front = metadatas.svg.front; 
        back = metadatas.svg.back;
        left = metadatas.svg.left;
        right = metadatas.svg.right;
        levelId = metadatas.levelId; 
        type_ = metadatas.type_; 
        title = metadatas.title; 
        text = metadatas.text; 
    }
}