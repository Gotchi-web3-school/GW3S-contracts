// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721Chest is IERC721Receiver, Ownable {
    mapping(address => mapping(uint256 => bool)) public isInside; // ERC721 contract => token id => boolean 
    bool public locked;
    address public opennedBy;
    uint256 public lastOpenned;
    uint256 public opennedCounter;

    // @notice Store the Items (ERC721) informations when deposited in the Chest 
    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) external override returns (bytes4) {
        isInside[msg.sender][tokenId] = true;
        return this.onERC721Received.selector;
    }

    function batchDeposit(address[] memory items, uint256[] memory ids) public returns(address[] memory items_, uint256[] memory ids_) {
        items_ = new address[](items.length);
        ids_ = new uint256[](ids.length);
    }

    // function open() external returns(address[] memory);
    // function extendOpenning() external;
    // function loot(address item, uint256 quantity) external returns(address, uint256);
    // function batchLoot(address[] memory items, uint256[] memory quantities) external returns(address[] memory, uint256[] memory);
    // function unlock() external;

    // function viewItems() external view returns(address[] memory items, uint256[] memory quantities);
}