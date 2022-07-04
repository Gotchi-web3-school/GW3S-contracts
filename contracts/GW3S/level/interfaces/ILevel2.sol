// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel {
    function initLevel() external returns(address);
    function complete() external returns (bool);
    function claim() external;
}