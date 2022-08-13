// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel13 {
    function initLevel13() external returns(address);
    function completeL13() external returns (bool);
    function openL13Chest() external returns(address[] memory loot, uint[] memory amount);
}