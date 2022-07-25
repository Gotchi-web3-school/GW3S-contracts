/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat');
const FILE_PATH = './helpers/facetsContracts.json';
const FILE_PATH_REWARDS = './helpers/ERC721RewardContracts.json';
const svg51 = "0x9366B466946C324F08e69f50303B9b47F2E302d9"
const svg52 = "0xfeBaD8DDFFA9f810AA8b3a877C9c4476b686d34E"

async function test () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, receipt, svg

  console.log("Deployer: ", player.address)

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
    reward = JSON.parse(await readFile(FILE_PATH_REWARDS, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  const RewardFacet = await ethers.getContractAt("RewardFacet", contracts.Diamond.mumbai.address)
  const ERC721RewardLevel = await ethers.getContractFactory("ERC721RewardLevel")

  console.log("\nDeploying reward 5.1...")
  const rewards = await ERC721RewardLevel.deploy("Gotchi web3 school l5s", "GW3Sl5s", svg51)
  await rewards.deployed()
  console.log("deployed !")
  contracts.secret = {level05s: undefined}
  contracts.secret["level05s"] = {mumbai: rewards.address}

  console.log("\nTransfering ownership to diamond...")
  tx = await rewards.transferOwnership(contracts.Diamond.mumbai.address)
  receipt = await tx.wait()
  
  console.log("\nDeploying reward 5.2...")
  const rewardh = await ERC721RewardLevel.deploy("Gotchi web3 school l5h", "GW3Sl5h", svg52)
  await rewardh.deployed()
  console.log("deployed !")
  contracts.hacker = {level05h: undefined}
  contracts.hacker["level05h"] = {mumbai: rewardh.address}
  
  console.log("\nTransfering ownership to diamond...")
  tx = await rewardh.transferOwnership(contracts.Diamond.mumbai.address)
  receipt = await tx.wait()

  console.log(`\nUpdating reward 5.1...`)
  tx = await RewardFacet.updateRewardAddress(rewards.address, 5, 1)
  receipt = await tx.wait()
  console.log("updated !")

  console.log(`\nUpdating reward 5.2...`)
  tx = await RewardFacet.updateRewardAddress(rewardh.address, 5, 2)
  receipt = await tx.wait()
  console.log("updated !")

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