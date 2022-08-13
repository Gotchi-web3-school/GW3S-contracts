// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel4 {
    function initLevel4() external returns(address);
    function completeL4() external returns (bool);
    function openL4Chest() external returns(address[] memory loot, uint[] memory amount);
}