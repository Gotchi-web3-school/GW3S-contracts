// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15; 

interface IERC721Chest {
    function isInside(address) external returns(bool); 
    function locked() external returns(bool);
    function opennedBy() external returns(address);
    function lastOpenned() external returns(uint256);
    function opennedCounter() external returns(uint256); 
    
    function open() external returns(address[] memory);
    function extendOpenning() external;
    function loot(address item, uint256 quantity) external returns(address, uint256);
    function batchLoot(address[] memory items, uint256[] memory quantities) external returns(address[] memory, uint256[] memory);
    function deposit(address[] memory items, uint256[] memory quantities) external returns(address[] memory, uint256[] memory);
    function unlock() external;

    function viewItems() external view returns(address[] memory items, uint256[] memory quantities);
}