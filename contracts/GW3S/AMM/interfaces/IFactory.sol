// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15; 
 
interface IFactory {
    function INIT_CODE_HASH() external returns(bytes32);
    function feeTo() external returns(address);
    function feeToSetter() external returns(address);
    function getPair(address, address) external returns(address);
    function allPairs(uint) external returns(address);
    function allPairsLength() external view returns (uint);
    
    function deployFactory(address player) external returns(address);
    function createPair(address, address) external returns (address);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}