// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Level-instance/interfaces/ILevel6Instance.sol";
import "../Level-instance/Level6Instance.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, RewardStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level6Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel6() external returns(address) {
        Level6Instance instance = new Level6Instance(msg.sender, s.router);

        s.level_completed[msg.sender][6] = false;
        s.level_running[msg.sender] = 6;
        s.level_instance[msg.sender][6] = address(instance);

        emit DeployedInstance(6, msg.sender, address(instance));
        return address(this);
    }

    function complete_l6() external hasCompleted(6) isRunning(6) {
        address ghst = ILevel6Instance(s.level_instance[msg.sender][6]).tokens(0);
        uint balance = IERC20(ghst).balanceOf(msg.sender);

        require(balance == 10001000000000000000, "level not completed yet");
        s.level_completed[msg.sender][6] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l6() external hasClaimed(6) {
        require(s.level_completed[msg.sender][6] == true, "Claim_l6: You need to complete the level first");

        s.level_reward[msg.sender][6] = true;
        IErc721RewardLevel(s.Erc721LevelReward[6][0]).safeMint(msg.sender);

        emit ClaimReward(0, msg.sender);
    }

}