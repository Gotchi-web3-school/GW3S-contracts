/* global ethers */
/* eslint prefer-const: "off" */

const { ethers } = require("hardhat");
const hardhat = require("hardhat")
const {readdir, readFile} = require('fs').promises
const {levels, secretLevels, hackerLevels} = require("../../helpers/constants.js")
const FILE_PATH = '../../img/common';
const FILE_PATH2 = '../../img/secret';
const FILE_PATH3 = '../../img/hacker';

async function deploySvg () {
  let tx, receipt, common, secret, hacker;

  try {
    svgContracts = JSON.parse(await readFile('./helpers/svgContracts.json', "utf-8"))
    rewardContracts = JSON.parse(await readFile('./helpers/ERC721RewardContracts.json', "utf-8"))
    contracts = JSON.parse(await readFile('./helpers/facetsContracts.json', "utf-8"))
  } catch (e) {
    console.log(e)
  }
  const RewardFacet = await ethers.getContractAt("RewardFacet", contracts.Diamond.mumbai.address)
  const ERC721Reward = await ethers.getContractFactory('ERC721RewardLevel')

  for(let i = 0; i < levels.length; i++) {
    console.log(`\nDeploying reward for level ${levels[i]}...\n`)

    const reward = await ERC721Reward.deploy(`Gotchi web3 school l${levels[i]}`, `GW3Sl${levels[i]}`, svgContracts.common[`level${levels[i]}`].mumbai)
    await reward.deployed()

    console.log("Transfer ownership to diamond")
    tx = await reward.transferOwnership(contracts.Diamond.mumbai.address)
    receipt = await tx.wait()
    
    console.log(`Storing reward address for level ${levels[i]}...\n`)
    tx = await RewardFacet.setRewardAddress(reward.address, i, 0)
    receipt = await tx.wait()

    rewardContracts.common[`level${levels[i]}`] = {mumbai: reward.address}
  }

  for(let i = 0; i < secretLevels.length; i++) {
    console.log(`\nDeploying reward for secret level ${secretLevels[i]}...\n`)
    const reward = await ERC721Reward.deploy(`Gotchi web3 school l${secretLevels[i]}s`, `GW3Sl${secretLevels[i]}s`, svgContracts.secret[`secretLevel${secretLevels[i]}`].mumbai)
    await reward.deployed()

    console.log("Transfer ownership to diamond")
    tx = await reward.transferOwnership(contracts.Diamond.mumbai.address)
    receipt = await tx.wait()

    console.log(`Storing reward for secret level ${secretLevels[i]}...\n`)
    tx = await RewardFacet.setRewardAddress(reward.address, i, 1)
    receipt = await tx.wait()

    rewardContracts.secret[`secretLevel${secretLevels[i]}`] = {mumbai: reward.address}
  }

  for(let i = 0; i < hackerLevels.length; i++) {
    console.log(`Deploying reward for hacker level  ${hackerLevels[i]}...\n`)
    const reward = await ERC721Reward.deploy(`Gotchi web3 school l${hackerLevels[i]}h`, `GW3Sl${hackerLevels[i]}h`, svgContracts.hacker[`hackerLevel${hackerLevels[i]}`].mumbai)
    await reward.deployed()

    console.log("Transfer ownership to diamond")
    tx = await reward.transferOwnership(contracts.Diamond.mumbai.address)
    receipt = await tx.wait()

    console.log(`Storing reward for hacker level ${hackerLevels[i]}...\n`)
    tx = await RewardFacet.setRewardAddress(reward.address, i, 2)
    receipt = await tx.wait()

    rewardContracts.hacker[`hackerLevel${hackerLevels[i]}`] = {mumbai: reward.address}
  }

  console.log("Contracts: ", rewardContracts)
  const ercAddress = JSON.stringify(rewardContracts)

  try {
    await writeFile('./helpers/ERC721RewardContracts.json', ercAddress)
  } catch (error) {
    console.log(error.message)
    throw error
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
    deploySvg()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deploySvg = deploySvg
