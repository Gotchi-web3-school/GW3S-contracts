// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level4Instance.sol";
import "../Level-instance/interfaces/ILevel4Instance.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, RewardStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";


contract Level4Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel4() external returns(address) {
        Level4Instance instance = new Level4Instance(msg.sender, s.router);
        
        s.level_completed[msg.sender][4] = false;
        s.level_running[msg.sender] = 4;
        s.level_instance[msg.sender][4] = address(instance);

        emit DeployedInstance(4, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l4() external hasCompleted(4) isRunning(4) returns (bool) {
        address ghst = ILevel4Instance(s.level_instance[msg.sender][4]).tokens(0);
        uint balance = IERC20(ghst).balanceOf(msg.sender);

        require(balance >= 1, "level not completed yet");
        s.level_completed[msg.sender][4] = true;
        emit Completed(4, msg.sender);
        
        return true;
    }
    
    /// @notice Claim reward.
    function claim_l4() external hasClaimed(4) {
        require(s.level_completed[msg.sender][4] == true, "Claim_l4: You need to complete the level first");

        s.level_reward[msg.sender][4] = true;
        IErc721RewardLevel(s.Erc721LevelReward[4][0]).safeMint(msg.sender);

        emit ClaimReward(4, msg.sender);
    }
}