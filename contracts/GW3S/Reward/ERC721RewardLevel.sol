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
    Metadatas private _metadatas;

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
        _metadatas.svg.front = front; 
        _metadatas.svg.back = back; 
        _metadatas.levelId = levelId; 
        _metadatas.type_ = type_; 
        _metadatas.title = title; 
        _metadatas.text = text; 
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _levelIdCounter.current();
        _levelIdCounter.increment();
        _safeMint(to, tokenId);
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
        bytes memory svgFrontByteCode = _metadatas.svg.front.code;
        bytes memory svgBackByteCode = _metadatas.svg.back.code;
        _svgFront = string(abi.encodePacked(svgFrontByteCode));
        _svgBack = string(abi.encodePacked(svgBackByteCode));
    }

    function getMetadas() public view returns(Metadatas memory metadatas) {
        return _metadatas;
    }
}