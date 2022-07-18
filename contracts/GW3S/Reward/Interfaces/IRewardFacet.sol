// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15; 
 
interface IRewardFacet {
    function setRewardAddress(address reward, uint256 levelId, uint256 _type) external;
    function updateRewardAddress(address reward, uint256 levelId, uint256 _type) external;
}