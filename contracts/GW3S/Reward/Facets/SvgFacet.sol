// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {LibAppStorage, SvgStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";
import {LibSvg} from "../../libraries/LibSvg.sol";

contract SvgFacet is Modifiers {
    /***********************************|
   |             Read Functions         |
   |__________________________________*/

    ///@notice Given an aavegotchi token id, return the combined SVG of its layers and its wearables
    ///@param _levelId the level identifier of the token to query
    ///@param _type the type of the level to query {LEVEL = 0, HIDDEN = 1, HACKER = 2}
    ///@return ag_ The final svg which contains the combined SVG of its layers and its wearables
    function getLevelRewardSvg(uint256 _levelId, uint256 _type) public view returns (string memory ag_) {
        require(_type <= 2, "storeSvg: type does not exist");
        SvgStorage storage s = LibAppStorage.svgDiamondStorage();
        require(s.svgLevelReward[_levelId][_type] != address(0), "SvgFacet: svg reward does not exist");

        bytes memory svg;
        svg = LibSvg.getSvg(_levelId, _type);

        ag_ = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">', svg, "</svg>"));
    }

    /***********************************|
   |             Write Functions        |
   |__________________________________*/

    ///@notice Allow an item manager to store a new  svg
    ///@param _svg the new svg string
    ///@param levelId the level identifier of the token to query
    ///@param _type the type of the level to query {LEVEL = 0, HIDDEN = 1, HACKER = 2}
    function storeSvg(string calldata _svg, uint256 levelId, uint256 _type) external onlyOwner {
        SvgStorage storage s = LibAppStorage.svgDiamondStorage();
        require(_type <= 2, "storeSvg: type does not exist");
        require(s.svgLevelReward[levelId][_type] == address(0), "SvgFacet: svg already existing");
        LibSvg.storeSvg(_svg, levelId, _type);
    }

    ///@notice Allow an item manager to store a new  svg
    ///@param _svg the new svg string
    ///@param levelId the level identifier of the token to query
    ///@param _type the type of the level to query {LEVEL = 0, HIDDEN = 1, HACKER = 2}
    function updateSvg(string calldata _svg, uint256 levelId, uint256 _type) external onlyOwner {
        require(_type <= 2, "storeSvg: type does not exist");
        LibSvg.storeSvg(_svg, levelId, _type);
    }
}
