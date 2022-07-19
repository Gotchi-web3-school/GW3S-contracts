// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {AppStorage, RewardStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level0Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);

    /// @notice Claim reward.
    function claim_l0() external hasClaimed(0) {
        s.level_reward[msg.sender][0] = true;
        IErc721RewardLevel(s.Erc721LevelReward[0][0]).safeMint(msg.sender);

        emit ClaimReward(0, msg.sender);
    }
} 