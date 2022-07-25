// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevel5Instance {
    function player() external view returns (address); 
    function token_() external view returns (address);
    function TOKENS_SYMBOL() external view returns (string memory);
    function TOKENS_NAME() external view returns (string memory);
    function completed() external view returns (uint8);

}
