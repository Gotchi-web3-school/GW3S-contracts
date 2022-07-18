// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721RewardLevel is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _levelIdCounter;
    address svg;

    constructor(string memory name, string memory ticker, address svg_) ERC721(name, ticker) {
        svg = svg_;
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

    function getSvg() public view returns(string memory _svg) {
        require(balanceOf(msg.sender) > 0, "getContent: You don't own the NFT");
        bytes memory svgByteCode = svg.code;
        _svg = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">', svgByteCode, "</svg>"));
    }
}