// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface ILevel10Instance {
    
    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    function player() external view returns (address); 
    function tokens(uint) external view returns (address);
    function TOKENS_SYMBOL(uint) external view returns (string memory);
    function TOKENS_NAME(uint) external view returns (string memory);
    function getTokenAddress(uint256) external view returns(address);
    
    function getPair() external returns(address);
    function deployToken(string memory name, string memory ticker, uint256 totalSupply) external;
}
