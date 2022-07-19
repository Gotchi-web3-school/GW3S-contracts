// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level10Instance.sol";
import "../Level-instance/interfaces/ILevel10Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level10Facet is Modifiers {

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel10() external returns(address) {
        Level10Instance instance = new Level10Instance(msg.sender);

        s.level_completed[msg.sender][10] = false;
        s.level_running[msg.sender] = 10;
        s.level_instance[msg.sender][10] = address(instance);

        emit DeployedInstance(10, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l10() external hasCompleted(10) isRunning(10) {
        address usdc = ILevel10Instance(s.level_instance[msg.sender][10]).tokens(0);
        address ghst = ILevel10Instance(s.level_instance[msg.sender][10]).tokens(1);
        address pair = ILevel10Instance(s.level_instance[msg.sender][10]).getPair();

        (uint112 reserve0, uint112 reserve1,) = IPair(pair).getReserves();
        
        uint256 quote = IRouter(s.router).quote(
            1 * 10 ** 18, 
            usdc < ghst ? reserve0 : reserve1, 
            usdc > ghst ? reserve0 : reserve1
            );

        require(quote >= 1000000000 * (10 ** 18), "Not billionaire yet !");

        s.level_completed[msg.sender][10] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l10() external hasClaimed(10) {
        require(s.level_completed[msg.sender][10] == true, "Claim_l10: You need to complete the level first");

        s.level_reward[msg.sender][10] = true;
        IErc721RewardLevel(s.Erc721LevelReward[10][0]).safeMint(msg.sender);

        emit ClaimReward(0, msg.sender);
    }

}