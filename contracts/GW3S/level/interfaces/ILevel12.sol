// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel12 {
    function initLevel12() external returns(address);
    function completeL12() external returns (bool);
    function openL12Chest() external returns(address[] memory loot, uint[] memory amount);
}