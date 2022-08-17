// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Modifiers} from "./LibLevel.sol";
import "../Reward/Interfaces/IERC721RewardLevel.sol";

library LibLevelReward {

   function mintReward(uint256 levelId, uint256 _type, address player) internal  {
      AppStorage storage s = LibAppStorage.diamondStorage();
      address svgContract = s.Erc721LevelReward[levelId][_type];

      IERC721RewardLevel(svgContract).safeMint(player);
   }
}
