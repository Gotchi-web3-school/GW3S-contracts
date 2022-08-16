// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {LibAppStorage, SvgStorage} from "../../libraries/LibAppStorage.sol";
import {Modifiers} from "../../libraries/LibLevel.sol";
import {LibSvg} from "../../libraries/LibSvg.sol";

contract SvgFacet is Modifiers {

    event RewardSvg(LibSvg.Svg indexed svg, uint256 levelId, uint256 _type);
    /***********************************|
   |             Read Functions         |
   |__________________________________*/

    ///@notice Given an aavegotchi token id, return the combined SVG of its layers and its wearables
    ///@param _levelId the level identifier of the token to query
    ///@param _type the type of the level to query {LEVEL = 0, HIDDEN = 1, HACKER = 2}
    ///@return front & back: The final front and back content of the card
    function getLevelRewardSvg(uint256 _levelId, uint256 _type) public view returns (string memory front, string memory back) {
        require(_type <= 2, "storeSvg: type does not exist");
        SvgStorage storage s = LibAppStorage.svgDiamondStorage();
        require(s.svgLevelReward[_levelId][_type].front != address(0), "SvgFacet: svg reward does not exist");

        (bytes memory front_, bytes memory back_) = LibSvg.getSvg(_levelId, _type);

        front = string(abi.encodePacked(front_));
        back = string(abi.encodePacked(back_));
    }

    /***********************************|
   |             Write Functions        |
   |__________________________________*/

    ///@notice Allow an item manager to store a new  svg
    ///@param _svg the new svg string
    ///@param levelId the level identifier of the token to query
    ///@param _type the type of the level to query {LEVEL = 0, HIDDEN = 1, HACKER = 2}
    function storeSvg(string[] calldata _svg, uint256 levelId, uint256 _type) external onlyOwner returns(LibSvg.Svg memory contracts){
        SvgStorage storage s = LibAppStorage.svgDiamondStorage();
        require(_type <= 2, "storeSvg: type does not exist");
        require(s.svgLevelReward[levelId][_type].front == address(0), "SvgFacet: svg already existing");

        contracts = LibSvg.storeSvg(_svg, levelId, _type);
        emit RewardSvg(contracts, levelId, _type);

        return contracts;
    }

    ///@notice Allow an item manager to store a new  svg
    ///@param _svg the new svg string
    ///@param levelId the level identifier of the token to query
    ///@param _type the type of the level to query {LEVEL = 0, HIDDEN = 1, HACKER = 2}
    function updateSvg(string[] calldata _svg, uint256 levelId, uint256 _type) external onlyOwner returns(LibSvg.Svg memory contracts) {
        require(_type <= 2, "storeSvg: type does not exist");

        contracts = LibSvg.storeSvg(_svg, levelId, _type);
        emit RewardSvg(contracts, levelId, _type);
        
        return contracts;
    }
}
