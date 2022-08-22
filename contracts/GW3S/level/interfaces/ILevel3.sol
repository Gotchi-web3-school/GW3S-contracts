// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel3 {
    function initLevel3() external returns(address);
    function completeL3() external returns (bool);
    function openL3Chest() external returns(address[] memory loots, uint[] memory amounts);
}