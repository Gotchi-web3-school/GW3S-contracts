// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface ILevel8Instance {
    function player() external view returns (address); 
    function tokens(uint) external view returns (address);
    function TOKENS_SYMBOL(uint) external view returns (string memory);
    function TOKENS_NAME(uint) external view returns (string memory);
    function getTokenAddress(uint256 index) external view returns(address);

    function getPair() external returns(address pair);
}
