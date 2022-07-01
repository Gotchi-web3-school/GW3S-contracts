// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

interface ILevel2Instance {
    function player() external view returns (address); 
    function tokens(uint) external view returns (address);
    function shipped() external view returns (bool);
    function TOKENS_SYMBOL(uint) external view returns (string memory);
    function TOKENS_NAME(uint) external view returns (string memory);

    function shipTokens() external;
}
