// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

interface ILevel {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);

    function complete() external;
    function claim() external;
}
