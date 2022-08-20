// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../Level-instance/Level13Instance.sol";
import "../Level-instance/interfaces/ILevel13Instance.sol";
import "../../AMM/interfaces/IFactory.sol";
import "../../AMM/interfaces/IRouter.sol";
import "../../AMM/interfaces/IPair.sol";
import "../../Reward/Interfaces/IERC721RewardLevel.sol";
import "../../../uniswap/v2-core/contracts/libraries/SafeMath.sol";
import {AppStorage, LibAppStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";

contract Level13Facet is Modifiers {
    using SafeMath for uint256;
    using SafeMath for uint112;

    function initLevel13() external returns(address) {
        Level13Instance instance = new Level13Instance(msg.sender, _s.level_factories[13][0], _s.level_factories[13][1]);

        _s.level_completed[msg.sender][13] = false;
        _s.level_running[msg.sender] = 13;
        _s.level_instance[msg.sender][13] = address(instance);

        emit DeployedInstance(13, msg.sender, address(instance));
        return address(instance);
    }

    function completeL13() external hasCompleted(13) isRunning(13) {
        address usdc = ILevel13Instance(_s.level_instance[msg.sender][13]).tokens(0);
        address ghst = ILevel13Instance(_s.level_instance[msg.sender][13]).tokens(1);

        (address pair1, address pair2) = ILevel13Instance(_s.level_instance[msg.sender][13]).getPairs();
        (uint112 reserve0A, uint112 reserve0B,) = IPair(pair1).getReserves();
        (uint112 reserve1A, uint112 reserve1B,) = IPair(pair2).getReserves();

        uint112 ghstReserve0 = ghst < usdc ? reserve0A : reserve0B;
        uint112 usdcReserve0 = usdc < ghst ? reserve0A : reserve0B;
        uint112 ghstReserve1 = ghst < usdc ? reserve1A : reserve1B;
        uint112 usdcReserve1 = usdc < ghst ? reserve1A : reserve1B;

        uint256 quote0 = IRouter(address(this)).quote(1e18, ghstReserve0, usdcReserve0);
        uint256 quote1 = IRouter(address(this)).quote(1e18, ghstReserve1.add(ghstReserve0), usdcReserve1.add(usdcReserve0));

        require(quote0 == 1e18, "Swap as been made here !");
        require(quote1.mul(2) <= quote0, "Not suceeded yet");

        _s.level_completed[msg.sender][13] = true;
        emit Completed(13, msg.sender);
    }
    
    /// @notice Claim reward.
    function openL13Chest() external returns(address[] memory, uint[] memory) {
        require(_s.level_completed[msg.sender][13] == true, "openL13Chest: You need to complete the level first");
        address[] memory loots = new address[](2); 
        uint256[] memory amounts = new uint256[](2); 

        if(_s.level_reward[msg.sender][13] == false)  {
            _s.level_reward[msg.sender][13] = true;
            IERC721RewardLevel(_s.Erc721LevelReward[13][0]).safeMint(msg.sender);

            loots[0] = _s.Erc721LevelReward[13][0];
            amounts[0] = 1;
        }

        emit LootChest(13, msg.sender, loots, amounts);
        return (loots, amounts);
    }

}