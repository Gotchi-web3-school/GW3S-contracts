/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
const FILE_PATH = './deployed.json';


async function deployDiamond () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  console.log("balance: ", ethers.utils.formatEther(await contractOwner.getBalance()), "MATIC")

  // attach DiamondLoupeFacet
  const level0Facet = await ethers.getContractAt('Level0Facet', contracts.Diamond.mumbai.address)

  // attach DiamondLoupeFacet
  const levelLoupeFacet = await ethers.getContractAt('ILevelLoupeFacet', contracts.Diamond.mumbai.address)
  
  console.log("level 0 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(contractOwner.address, 0))
  await level0Facet.claim_l0()

  const timeout = new Promise(() => {
    setTimeout(async () => {
        console.log("level 0 ?: ", await levelLoupeFacet.hasClaimedLevel(contractOwner.address, 0))
    },1000)
  }) 

  await timeout
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  deployDiamond()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployDiamond = deployDiamond
