/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat');
const {metadatas} = require("../../helpers/constants.js");
const FILE_PATH = './helpers/facetsContracts.json';
const FILE_PATH_REWARDS = './helpers/ERC721RewardContracts.json';

async function test () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, receipt

  const ids = [0, 1, 2]
  const types = [0, 1, 2]

  console.log("Deployer: ", player.address)
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
    reward = JSON.parse(await readFile(FILE_PATH_REWARDS, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  // Setting the facets smart contracts
  const SvgLoupeFacet = await ethers.getContractAt("SvgLoupeFacet", contracts.Diamond.mumbai.address)
  const RewardFacet = await ethers.getContractAt("RewardFacet", contracts.Diamond.mumbai.address)
  const ERC721RewardLevel = await ethers.getContractFactory("ERC721RewardLevel")

  for (id of ids) {
    try {
      const _addrObj = {};
      const _chainObj = {};
      let _networksObj = {};
  
      console.log("Get the svgs contracts addresses\n")
      const svgContracts = await SvgLoupeFacet.getSvgLevelReward(id, 0)
      metadatas[id].svg.front = svgContracts.front
      metadatas[id].svg.back = svgContracts.back
      
      console.log(`Deploying reward ${ids[id]}.0...`)
      const rewardLevel = await ERC721RewardLevel.deploy(
        `Gotchi web3 school l${id}`, 
        `GW3S${id}l`, 
        metadatas[id].svg.front,
        metadatas[id].svg.back,
        metadatas[id].levelId,
        metadatas[id].type,
        metadatas[id].title,
        metadatas[id].text,
        )
      await rewardLevel.deployed()
      console.log("deployed !\n")

      console.log("Store the Reward contract address in the diamond RewardFacet...")
      tx = await RewardFacet.updateRewardLevel(rewardLevel.address, id, 0)
      await tx.wait()
      console.log("Address stored sucessfully !\n")
  
      console.log("Transfer ownership to the diamond...")
      tx = await rewardLevel.transferOwnership(contracts.Diamond.mumbai.address)
      await tx.wait()
      console.log("Ownership transfered !\n")
  
      console.log("update the file contracts obj...\n")
      _addrObj.address = rewardLevel;
      _chainObj[hardhat.network.name] = _addrObj;
      _networksObj = { ...contracts[`Level${id}0`], ..._chainObj };
      contracts.common = _networksObj;
    } catch (error) {
      console.log(error)
      console.log('')
    }
  }

  const obj = JSON.stringify(contracts)

  try {
    await writeFile(FILE_PATH_REWARDS, obj);
  } catch (e) {
    console.log(e.message);
    throw e;
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  test()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}