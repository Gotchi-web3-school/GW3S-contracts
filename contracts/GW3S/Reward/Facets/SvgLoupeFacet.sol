// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {LibAppStorage, SvgStorage} from "../../libraries/LibAppStorage.sol";
import {Level, Difficulty} from "../../libraries/LibLevel.sol";
import {LibSvg} from "../../libraries/LibSvg.sol";

contract SvgLoupeFacet {

    function getSvgLevelReward(uint256 levelId, uint _type) external view returns(LibSvg.Svg memory svgs) {
        SvgStorage storage svg = LibAppStorage.svgDiamondStorage();
        svgs = svg.svgLevelReward[levelId][_type];
    }
}