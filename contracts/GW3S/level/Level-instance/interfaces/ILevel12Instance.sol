// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface ILevel12Instance {
    
    event Deployed(string indexed name, string indexed ticker, uint256 indexed supply);

    function player() external view returns (address); 
    function tokens(uint) external view returns (address);
    function TOKENS_SYMBOL(uint) external view returns (string memory);
    function TOKENS_NAME(uint) external view returns (string memory);
    function router() external view returns (address);
    function factories(uint) external view returns (address);
    function getPairs() external returns(address pair1, address pair2);
}
