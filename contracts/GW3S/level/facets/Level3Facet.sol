// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "../Level-instance/Level3Instance.sol";
import "../Level-instance/interfaces/ILevel3Instance.sol";
import '../../../uniswap/v2-core/contracts/UniswapV2Factory.sol';
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";


contract Level3Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel3() external returns(address) {
        Level3Instance instance = new Level3Instance(msg.sender, s.router);
        s.level_completed[msg.sender][3] = false;
        s.level_running[msg.sender] = 3;
        s.level_instance[msg.sender][3] = address(instance);

        emit DeployedInstance(3, msg.sender, address(instance));
        return address(instance);
    }

    // TODO: condition to win
    function complete_l3() external hasCompleted(3) isRunning(3) returns (bool) {
        address ghst = ILevel3Instance(s.level_instance[msg.sender][3]).tokens(1);
        uint balance = IERC20(ghst).balanceOf(msg.sender);

        require(balance >= 1, "level not completed yet");

        s.level_completed[msg.sender][3] = true;
        emit Completed(3, msg.sender);
        
        return true;
    }
    
    /// @notice Claim reward.
    function claim_l3() external hasClaimed(3) {
        require(s.level_completed[msg.sender][3] == true, "Claim_l3: You need to complete the level first");

        s.level_reward[msg.sender][3] = true;
        IErc721RewardLevel(s.Erc721LevelReward[3][0]).safeMint(msg.sender);

        emit ClaimReward(3, msg.sender);
    }
}