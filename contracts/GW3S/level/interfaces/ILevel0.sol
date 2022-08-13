// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel0 {
    function completeL0() external;
    function openL0Chest() external returns(address[] memory loot, uint[] memory amount);
}
