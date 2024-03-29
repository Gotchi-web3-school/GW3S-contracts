// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ILevelLoupeFacet {
    function getAddress(uint256 levelId) external view returns (address addr);
    function getTitle(uint256 levelId) external view returns (string memory title);
    function getLevelDifficulty(uint256 levelId) external view returns (string memory title);
    function hasCompletedLevel(address account, uint256 levelId) external view returns (bool result);
    function hasClaimedLevel(address account, uint256 levelId) external view returns (bool result);
    function getRunningLevel(address account) external view returns (uint256 result);
    function getLevelInstanceByAddress(address account, uint256 levelId) external view returns (address result);
    function getFactoryLevel(uint256 levelId, uint8 pos) external view returns (address result);
    function getTokensLevel(uint256 levelId) external view returns (address[] memory result);
    function getRewardAddress(uint256 levelId, uint256 type_) external view returns (address result);
}
