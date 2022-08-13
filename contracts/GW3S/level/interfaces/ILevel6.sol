// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel6 {
    function initLevel6() external returns(address);
    function completeL6() external returns (bool);
    function openL6Chest() external returns(address[] memory loot, uint[] memory amount);
    function getTokens() external view returns(address[] memory);
    function getFactory() external view returns(address);
    function getPair(address token0, address token1) public returns(address pair);
}