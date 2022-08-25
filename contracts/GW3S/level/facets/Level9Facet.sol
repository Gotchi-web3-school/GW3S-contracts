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

    function initLevel9() external returns(address) {
        Level9Instance instance = new Level9Instance(msg.sender, _s.level_factories[9][0]);

        _s.level_completed[msg.sender][9] = false;
        _s.level_running[msg.sender] = 9;
        _s.level_instance[msg.sender][9] = address(instance);

        emit DeployedInstance(9, msg.sender, address(instance));
        return address(instance);
    }

    function completeL9() external hasCompleted(9) isRunning(9) {
        address usdc = ILevel9Instance(_s.level_instance[msg.sender][9]).tokens(0);
        address playerToken = ILevel9Instance(_s.level_instance[msg.sender][9]).tokens(1);
        address pair = ILevel9Instance(_s.level_instance[msg.sender][9]).getPair();

        (uint112 reserve0, uint112 reserve1,) = IPair(pair).getReserves();
        
        // Quote for 1 token created by player
        uint256 quote = IRouter(address(this)).quote(
            1e18, 
            playerToken < usdc ? reserve0 : reserve1, 
            usdc < playerToken ? reserve0 : reserve1
            );

        require(IToken(playerToken).balanceOf(msg.sender).mul(quote).div(1e18) >= 1000000e18, "Not millionaire yet !");

        _s.level_completed[msg.sender][9] = true;
        emit Completed(9, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL9Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][9] == true, "openL9Chest: You need to complete the level first");
        address[] memory loots = new address[](2); 
        uint256[] memory amounts = new uint256[](2); 

        if(_s.level_reward[msg.sender][9] == false) {
            _s.level_reward[msg.sender][9] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[9][0]).safeMint(msg.sender);

            loots[0] = _s.Erc721LevelReward[9][0];
            amounts[0] = 1;
        }

        emit LootChest(9, msg.sender, loots, amounts);
        return (loots, amounts);
    }

}