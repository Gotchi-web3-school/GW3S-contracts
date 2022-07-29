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

    event ClaimReward(uint256 indexed level, address indexed player);
    event Completed(uint256 indexed level, address indexed player);
    event DeployedInstance(uint256 indexed level, address indexed player, address instance);

    function initLevel13() external returns(address) {
        Level13Instance instance = new Level13Instance(msg.sender, s.level_factories[13][0], s.level_factories[13][1]);

        s.level_completed[msg.sender][13] = false;
        s.level_running[msg.sender] = 13;
        s.level_instance[msg.sender][13] = address(instance);

        emit DeployedInstance(13, msg.sender, address(instance));
        return address(instance);
    }

    function complete_l13() external hasCompleted(13) isRunning(13) {
        address usdc = ILevel13Instance(s.level_instance[msg.sender][13]).tokens(0);
        address ghst = ILevel13Instance(s.level_instance[msg.sender][13]).tokens(1);

        (address pair1, address pair2) = ILevel13Instance(s.level_instance[msg.sender][13]).getPairs();
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