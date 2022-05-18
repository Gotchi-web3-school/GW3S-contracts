// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import {AppStorage, LibAppStorage} from "../libraries/LibAppStorage.sol";
import {Modifiers} from "../libraries/LibLevel.sol";

contract Level0Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);

    /// @notice Claim reward.
    function claim_l0() external hasClaimed(0) {
        s.level_reward[msg.sender][0] = true;
        emit ClaimReward(0, msg.sender);
    }
} 