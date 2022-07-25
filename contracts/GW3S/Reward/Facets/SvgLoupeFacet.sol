// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import {LibAppStorage, SvgStorage} from "../../libraries/LibAppStorage.sol";
import {Level, Difficulty} from "../../libraries/LibLevel.sol";

contract SvgLoupeFacet {

    function getSvgLevelReward(uint256 levelId, uint _type) external view returns (address addr) {
        SvgStorage storage svg = LibAppStorage.svgDiamondStorage();
        addr = svg.svgLevelReward[levelId][_type];
    }
}