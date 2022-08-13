// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel8 {
    function initLevel8() external returns(address);
    function completeL8() external returns (bool);
    function openL8Chest() external returns(address[] memory loot, uint[] memory amount);
}