// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../Level-instance/Level9Instance.sol";
import "../Level-instance/interfaces/ILevel9Instance.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../AMM/interfaces/IToken.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level9Facet is Modifiers {
    using SafeMath for uint256;

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel9() external returns(address) {
        Level9Instance instance = new Level9Instance(msg.sender);

        s.level_completed[msg.sender][9] = false;
        s.level_running[msg.sender] = 9;
        s.level_instance[msg.sender][9] = address(instance);

        emit DeployedInstance(9, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l9() external hasCompleted(9) isRunning(9) {
        address usdc = ILevel9Instance(s.level_instance[msg.sender][9]).tokens(0);
        address player_token = ILevel9Instance(s.level_instance[msg.sender][9]).tokens(1);
        address pair = ILevel9Instance(s.level_instance[msg.sender][9]).getPair();

        (uint112 reserve0, uint112 reserve1,) = IPair(pair).getReserves();
        
        // Quote for 1 token created by player
        uint256 quote = IRouter(address(this)).quote(
            1e18, 
            player_token < usdc ? reserve0 : reserve1, 
            usdc < player_token ? reserve0 : reserve1
            );

        require(IToken(player_token).balanceOf(msg.sender).mul(quote).div(1e18) >= 1000000e18, "Not millionaire yet !");

        s.level_completed[msg.sender][9] = true;
        emit Completed(0, msg.sender);
    }
    
    /// @notice Claim reward.
    function claim_l9() external hasClaimed(9) {
        require(s.level_completed[msg.sender][9] == true, "Claim_l9: You need to complete the level first");

        s.level_reward[msg.sender][9] = true;
        IErc721RewardLevel(s.Erc721LevelReward[9][0]).safeMint(msg.sender);

        emit ClaimReward(0, msg.sender);
    }

}