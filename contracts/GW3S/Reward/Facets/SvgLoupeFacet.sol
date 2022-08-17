// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {LibAppStorage, SvgStorage} from "../../libraries/LibAppStorage.sol";
import {Level, Difficulty} from "../../libraries/LibLevel.sol";
import {Svg} from "../../libraries/LibSvg.sol";

contract SvgLoupeFacet {

    function getSvgLevelReward(uint256 levelId, uint256 _type) external view returns(Svg memory contracts) {
        SvgStorage storage s = LibAppStorage.svgDiamondStorage();
        contracts = s.svgLevelReward[levelId][_type];
        return contracts;
    }
}