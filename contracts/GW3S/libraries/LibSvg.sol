// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {LibAppStorage, SvgStorage} from "./LibAppStorage.sol";

library LibSvg {
    event StoreSvg(uint256 levelId, uint256 _type);
    event UpdateSvg(uint256 levelId, uint256 _type);

    enum LevelTypes{LEVEL, HIDDEN, HACKER}

    function getSvg(uint256 levelId, uint256 _type) internal view returns (bytes memory svg_) {
        SvgStorage storage s = LibAppStorage.svgDiamondStorage();
        address svgContract = s.svgLevelReward[levelId][_type];
        assert(svgContract != address(0));
        svg_ = svgContract.code;
    }

    function storeSvgInContract(string calldata _svg) internal returns (address svgContract) {
        require(bytes(_svg).length < 24576, "SvgStorage: Exceeded 24,576 bytes max contract size");
        // 61_00_00 -- PUSH2 (size)
        // 60_00 -- PUSH1 (code position)
        // 60_00 -- PUSH1 (mem position)
        // 39 CODECOPY
        // 61_00_00 PUSH2 (size)
        // 60_00 PUSH1 (mem position)
        // f3 RETURN
        bytes memory init = hex"610000_600e_6000_39_610000_6000_f3";
        bytes1 size1 = bytes1(uint8(bytes(_svg).length));
        bytes1 size2 = bytes1(uint8(bytes(_svg).length >> 8));
        init[2] = size1;
        init[1] = size2;
        init[10] = size1;
        init[9] = size2;
        bytes memory code = abi.encodePacked(init, _svg);

        assembly {
            svgContract := create(0, add(code, 32), mload(code))
            if eq(svgContract, 0) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
    }

    function storeSvg(string calldata _svg, uint256 levelId, uint256 _type) internal returns(address) {
        SvgStorage storage s = LibAppStorage.svgDiamondStorage();
        emit StoreSvg(levelId, _type);
        address svgContract = storeSvgInContract(_svg);
        s.svgLevelReward[levelId][_type] = svgContract;
        return svgContract;
    }   
}
