// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15; 
 
interface IERC721RewardLevel {
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

    function safeMint(address to) external;
    function supportsInterface(bytes4 interfaceId) external;
    function getSvg() external view returns(string memory _svgFront, string memory _svgBack);
    function getMetadas() external view returns(Metadatas memory metadatas);

    function balanceOf(address owner) external view  returns (uint256);
    function ownerOf(uint256 tokenId) external view  returns (address);
    function name() external view  returns (string memory);
    function symbol() external view  returns (string memory);
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view  returns (address);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address owner, address operator) external view  returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function tokenOfOwnerByIndex(address owner, uint256 index) external view  returns (uint256);
    function totalSupply() external view  returns (uint256);
    function tokenByIndex(uint256 index) external view  returns (uint256);

    function owner() external view returns (address);
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;

}