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
        address front,
        address back,
        uint256 levelId,
        string memory type_,
        string memory title,
        string memory text
        ) ERC721(name, ticker) {
        metadatas.svg.front = front; 
        metadatas.svg.back = back; 
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

    function getSvg() public view returns(string memory _svgFront, string memory _svgBack) {
        require(balanceOf(msg.sender) > 0, "getContent: You don't own the NFT");
        bytes memory svgFrontByteCode = metadatas.svg.front.code;
        bytes memory svgBackByteCode = metadatas.svg.back.code;
        _svgFront = string(abi.encodePacked(svgFrontByteCode));
        _svgBack = string(abi.encodePacked(svgBackByteCode));
    }

    function getMetadas() public view returns(
        address front,
        address back,
        uint256 levelId,
        string memory type_,
        string memory title,
        string memory text) {
        front = metadatas.svg.front; 
        back = metadatas.svg.back; 
        levelId = metadatas.levelId; 
        type_ = metadatas.type_; 
        title = metadatas.title; 
        text = metadatas.text; 
    }
}