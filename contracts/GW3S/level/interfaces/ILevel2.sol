// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel2 {
    function initLevel2() external returns(address);
    function completeL2() external returns (bool);
    function openL2Chest() external returns(address[] memory loot, uint[] memory amount);
}