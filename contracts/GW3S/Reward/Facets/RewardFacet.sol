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

   function setRewardLevel(address reward, uint256 levelId, uint256 _type) external onlyOwner {
    require(reward != address(0), "setRewardLevel: address can't be 0");
    require(_s.Erc721LevelReward[levelId][_type] == address(0), "setRewardLevel: levelId is already used");

    _s.Erc721LevelReward[levelId][_type] = reward;
    emit RewardAddress(reward, levelId, _type);
   }

   function updateRewardLevel(address reward, uint256 levelId, uint256 _type) external onlyOwner {
    require(reward != address(0), "updateRewardLevel: address can't be 0");

    _s.Erc721LevelReward[levelId][_type] = reward;
    emit RewardAddress(reward, levelId, _type);
   }
}
