// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";
import {ERC721RewardLevel} from "../ERC721RewardLevel.sol";

contract RewardFacet is Modifiers {
    event RewardAddress(address indexed reward, uint256 levelId, uint256 _type);

    /***********************************|
   |             Write Functions        |
   |__________________________________*/

   function setRewardAddress(address reward, uint256 levelId, uint256 _type) external onlyOwner {
    require(reward != address(0), "setRewardAddress: address can't be 0");
    require(s.Erc721LevelReward[levelId][_type] == address(0), "setRewardAddress: levelId is already used");

    s.Erc721LevelReward[levelId][_type] = reward;
    emit RewardAddress(reward, levelId, _type);
   }

   function updateRewardAddress(address reward, uint256 levelId, uint256 _type) external onlyOwner {
    require(reward != address(0), "setRewardAddress: address can't be 0");

    s.Erc721LevelReward[levelId][_type] = reward;
    emit RewardAddress(reward, levelId, _type);
   }
}
