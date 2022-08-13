// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel1 {
    function initLevel1() external returns(address);
    function completeL1() external returns (bool);
    function openL1Chest() external returns(address[] memory loot, uint[] memory amount);
}