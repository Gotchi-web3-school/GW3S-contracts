// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel7 {
    function initLevel7() external returns(address);
    function completeL7() external returns (bool);
    function openL7Chest() external returns(address[] memory loot, uint[] memory amount);
}