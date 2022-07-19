// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../../uniswap/v2-core/contracts/libraries/SafeMath.sol";
import "../Level-instance/Level13Instance.sol";
import "../Level-instance/interfaces/ILevel13Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, RewardStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level13Facet is Modifiers {
    using SafeMath for uint256;

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel13() external returns(address) {
        Level13Instance instance = new Level13Instance(msg.sender, s.router);

        s.level_completed[msg.sender][13] = false;
        s.level_running[msg.sender] = 13;
        s.level_instance[msg.sender][13] = address(instance);

        emit DeployedInstance(13, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l13() external hasCompleted(13) isRunning(13) {
        address factory0 = ILevel13Instance(s.level_instance[msg.sender][13]).factories(0);
        address factory1 = ILevel13Instance(s.level_instance[msg.sender][13]).factories(1);
        address usdc = ILevel13Instance(s.level_instance[msg.sender][13]).tokens(0);
        address ghst = ILevel13Instance(s.level_instance[msg.sender][13]).tokens(1);

        address pair0 = ILevel13Instance(s.level_instance[msg.sender][13]).getPair(factory0);
        address pair1 = ILevel13Instance(s.level_instance[msg.sender][13]).getPair(factory1);
        (uint112 reserve00, uint112 reserve01,) = IPair(pair0).getReserves();
        (uint112 reserve10, uint112 reserve11,) = IPair(pair1).getReserves();
        
        uint amountUSDC = usdc < ghst ? reserve00 + reserve10 : reserve01 + reserve11;
        uint amountGHST = ghst < usdc ? reserve00 + reserve10 : reserve01 + reserve11;

        require(amountUSDC.mul(10000) / amountGHST <= 5000, "Not suceeded yet");

        s.level_completed[msg.sender][13] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l13() external hasClaimed(13) {
        require(s.level_completed[msg.sender][13] == true, "Claim_l13: You need to complete the level first");

        s.level_reward[msg.sender][13] = true;
        IErc721RewardLevel(s.Erc721LevelReward[13][0]).safeMint(msg.sender);

        emit ClaimReward(0, msg.sender);
    }

}