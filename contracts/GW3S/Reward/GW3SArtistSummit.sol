// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GW3SArtistSummit is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    struct Svg {
        address front;
        address back;
        address left;
        address right;
    }

    struct Metadatas {
        Svg svg;
        string type_;
        string title;
        string text;
    }

    Counters.Counter private _levelIdCounter;
    mapping(uint256 => Metadatas) public metadatas;
    string public baseURI;

    event NewURI(string indexed uri);

    constructor(string memory name, string memory ticker) ERC721(name, ticker) {
        _levelIdCounter.increment();
    }

    function safeMint(
        address to, 
        Svg calldata svg, 
        string memory title, 
        string memory text, 
        string memory baseURI_
    ) public onlyOwner {
        uint256 tokenId = _levelIdCounter.current();

        // Set metadatas of this NFT.
        metadatas[tokenId].svg = svg;
        metadatas[tokenId].type_ = "GMI";
        metadatas[tokenId].title = title;
        metadatas[tokenId].text = text;

        // Update the baseURI with the new ipfs link to the current id.
        setURI(baseURI_);
        emit NewURI(baseURI);

        _safeMint(to, tokenId);
        _levelIdCounter.increment();
    }

    function getSvg(uint256 tokenId) public view returns(string memory _svgFront, string memory _svgBack, string memory _svgLeft, string memory _svgRight) {
        bytes memory svgFrontByteCode = metadatas[tokenId].svg.front.code;
        bytes memory svgBackByteCode = metadatas[tokenId].svg.back.code;
        bytes memory svgLeftByteCode = metadatas[tokenId].svg.left.code;
        bytes memory svgRightByteCode = metadatas[tokenId].svg.right.code;
        _svgFront = string(svgFrontByteCode);
        _svgBack = string(svgBackByteCode);
        _svgLeft = string(svgLeftByteCode);
        _svgRight = string(svgRightByteCode);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".svg")) : "";
    }

    function setURI(string memory uri) public onlyOwner {
        baseURI = uri;
        emit NewURI(uri);
    }
}