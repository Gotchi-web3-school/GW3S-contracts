// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15; 
 
interface IPair {
    function factory()external view returns (address);
    function token0()external view returns (address);
    function token1()external view returns (address);
    function price0CumulativeLast()external view returns (uint);
    function price1CumulativeLast()external view returns (uint);
    function kLast()external view returns (uint);

    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
    function initialize(address _token0, address _token1) external;
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
}