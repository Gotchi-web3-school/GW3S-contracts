// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface ILevel4Instance {
    function player() external view returns (address); 
    function tokens(uint) external view returns (address);
    function getPair(address token0, address token1, address factory) external returns(address pair);
}
