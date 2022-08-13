// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel10 {
    function initLevel10() external returns(address);
    function completeL10() external returns (bool);
    function openL10Chest() external returns(address[] memory loot, uint[] memory amount);
}