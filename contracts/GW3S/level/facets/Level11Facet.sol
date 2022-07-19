// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level11Instance.sol";
import "../Level-instance/interfaces/ILevel11Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, RewardStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level11Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel11() external returns(address) {
        Level11Instance instance = new Level11Instance(msg.sender, s.router);
        s.level_completed[msg.sender][11] = false;
        s.level_running[msg.sender] = 11;
        s.level_instance[msg.sender][11] = address(instance);

        emit DeployedInstance(11, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l11() external hasCompleted(11) isRunning(11) {
        require(ILevel11Instance(s.level_instance[msg.sender][11]).success(), "Not suceeded yet");

        s.level_completed[msg.sender][11] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l11() external hasClaimed(11) {
        require(s.level_completed[msg.sender][11] == true, "Claim_l11: You need to complete the level first");

        s.level_reward[msg.sender][11] = true;
        IErc721RewardLevel(s.Erc721LevelReward[11][0]).safeMint(msg.sender);

        emit ClaimReward(0, msg.sender);
    }

}