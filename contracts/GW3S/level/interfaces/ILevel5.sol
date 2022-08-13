// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel5 {
    function initLevel5() external returns(address);
    function completeL5() external returns (bool);
    function openL5Chest() external returns(address[] memory loot, uint[] memory amount);
}