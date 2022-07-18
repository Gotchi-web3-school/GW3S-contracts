// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {LibAppStorage, SvgStorage, RewardStorage} from "./LibAppStorage.sol";
import "../Reward/interfaces/IERC721RewardLevel.sol";

library LibLevelReward {

   function mintReward(uint256 levelId, uint256 _type, address player) internal  {
    RewardStorage storage r = LibAppStorage.rewardDiamondStorage();
    address svgContract = r.Erc721LevelReward[levelId][_type];

    IErc721RewardLevel(svgContract).safeMint(player);
   }
}
