// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel11 {
    function initLevel11() external returns(address);
    function completeL11() external returns (bool);
    function openL11Chest() external returns(address[] memory loot, uint[] memory amount);
}