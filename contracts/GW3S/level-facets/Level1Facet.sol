// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {AppStorage, LibAppStorage} from "../libraries-facets/LibAppStorage.sol";
import {Modifiers} from "../libraries-facets/LibLevel.sol";

contract Level1Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);

    function complete_l1() external hasCompleted(1) isRunning(1) {
        s.level_completed[msg.sender][1] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l1() external hasClaimed(1) {
        require(s.level_completed[msg.sender][1] == true, "Claim_l1: You need to complete the level first");
        s.level_reward[msg.sender][1] = true;
        emit ClaimReward(0, msg.sender);
    }
}