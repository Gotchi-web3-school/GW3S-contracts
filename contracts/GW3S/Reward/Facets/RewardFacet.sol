// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {LibAppStorage, RewardStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";
//import {RewardAddress} from "../../libraries/LibReward.sol";

contract RewardFacet is Modifiers {
    event RewardAddress(address indexed reward, uint256 levelId, uint256 _type);

    /***********************************|
   |             Read Functions         |
   |__________________________________*/

   

    /***********************************|
   |             Write Functions        |
   |__________________________________*/

   function setRewardAddress(address reward, uint256 levelId, uint256 _type) external onlyOwner {
    require(reward != address(0), "setRewardAddress: address can't be 0");
    RewardStorage storage r = LibAppStorage.rewardDiamondStorage();
    require(r.levelReward[levelId][_type] != address(0), "setRewardAddress: address can't be 0");

    r.levelReward[levelId][_type] = reward;
    emit RewardAddress(reward, levelId, _type);
   }

   function updateRewardAddress(address reward, uint256 levelId, uint256 _type) external onlyOwner {
    require(reward != address(0), "setRewardAddress: address can't be 0");
    RewardStorage storage r = LibAppStorage.rewardDiamondStorage();

    r.levelReward[levelId][_type] = reward;
    emit RewardAddress(reward, levelId, _type);
   }
}
