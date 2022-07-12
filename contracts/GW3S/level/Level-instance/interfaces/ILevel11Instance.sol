// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface ILevel11Instance {
    
    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    function tokens(uint) external view returns (address);
    function player() external view returns (address); 
    function success() external view returns (bool); 
    function TOKENS_SYMBOL(uint) external view returns (string memory);
    function TOKENS_NAME(uint) external view returns (string memory);
    function factory() external view returns (address); 
    function router() external view returns (address);
    
    function getPair() external returns(address);
    function swap(uint amountIn, uint amountOutMin, address[] calldata path) external returns(bool);
    function getQuote() external returns(uint256 quote);
}
