// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel9 {
    function initLevel9() external returns(address);
    function completeL9() external returns (bool);
    function openL9Chest() external returns(address[] memory loot, uint[] memory amount);
}