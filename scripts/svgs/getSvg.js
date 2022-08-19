/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile } = require('fs').promises;
const { ethers } = require('hardhat');
const FILE_PATH = './helpers/facetsContracts.json';


async function test () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, receipt, svg

  console.log("Deployer: ", player.address)

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }


  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  const SvgFacet = await ethers.getContractAt("SvgFacet", contracts.Diamond.mumbai.address)
  const SvgLoupeFacet = await ethers.getContractAt("SvgLoupeFacet", contracts.Diamond.mumbai.address)

  console.log((await SvgFacet.getLevelRewardSvg(2, 0)).front)
  
  console.log(await SvgLoupeFacet.getSvgLevelReward(2, 0))
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