/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat');
const {metadatas} = require("../../helpers/constants.js");
const FILE_PATH = './helpers/facetsContracts.json';
const SVG_PATH = './helpers/svgContracts.json';
const FILE_PATH_REWARDS = './helpers/LevelRewards.json';

async function test () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, receipt

  // Put the level card Reward ERC721 you want to change in ids
  const ids = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  const types = [0, 1, 2]

  console.log("Deployer: ", player.address)
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
    svgs = JSON.parse(await readFile(SVG_PATH, "utf-8"))
    rewards = JSON.parse(await readFile(FILE_PATH_REWARDS, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  // Setting the facets smart contracts
  const SvgLoupeFacet = await ethers.getContractAt("SvgLoupeFacet", contracts.Diamond.mumbai.address)
  const RewardFacet = await ethers.getContractAt("RewardFacet", contracts.Diamond.mumbai.address)
  const ERC721RewardLevel = await ethers.getContractFactory("ERC721RewardLevel")

  for (id of ids) {
    try {
      metadatas[id].svg.front = svgs.common[`level${id}`].mumbai.front
      metadatas[id].svg.back = svgs.common[`level${id}`].mumbai.back
      metadatas[id].svg.left = svgs.common.leftSide[hardhat.network.name]
      metadatas[id].svg.right = svgs.common.rightSide[hardhat.network.name]
      
      // Deploy the new NFT reward
      console.log(`Deploying reward ${ids[id]}.0...`)
      const rewardLevel = await ERC721RewardLevel.deploy(
        `Gotchi web3 school l${id}`, 
        `GW3Sl${id}`,
        metadatas[id].levelId,
        metadatas[id].type,
        metadatas[id].title,
        metadatas[id].text,
        )
      await rewardLevel.deployed()
      console.log("deployed !\n")
      
      // Set svgs content
      console.log("Store the svgs in contract...")
      tx = await rewardLevel.setSvg(metadatas[id].svg.front, metadatas[id].svg.back, metadatas[id].svg.left, metadatas[id].svg.right)
      await tx.wait()
      console.log("Address stored sucessfully !\n")

      // Change the old NFT reward by new one on th Diamond school
      console.log("Store the Reward contract address in the diamond RewardFacet...")
      tx = await RewardFacet.updateRewardLevel(rewardLevel.address, id, 0)
      await tx.wait()
      console.log("Address stored sucessfully !\n")
      
      // Transfert the ownership to the diamond
      console.log("Transfer ownership to the diamond...")
      tx = await rewardLevel.transferOwnership(contracts.Diamond.mumbai.address)
      await tx.wait()
      console.log("Ownership transfered !\n")
  
      console.log("update the file contracts obj...\n")
      let mumbai = rewardLevel.address
      let obj = {mumbai}
      
      rewards.common[`level${id}`] = obj;
    } catch (error) {
      console.log(error)
      console.log('')
    }
  }

  const obj = JSON.stringify(rewards)

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