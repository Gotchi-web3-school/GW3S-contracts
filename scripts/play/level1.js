/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
const FILE_PATH = './deployed.json';


async function level1 () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]

  console.log(contractOwner.address)

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  console.log("balance: ", ethers.utils.formatEther(await contractOwner.getBalance()), "MATIC")

  // attach DiamondLoupeFacet
  const level1Facet = await ethers.getContractAt('Level1Facet', contracts.Diamond.mumbai.address)

  // attach DiamondLoupeFacet
  const levelLoupeFacet = await ethers.getContractAt('ILevelLoupeFacet', contracts.Diamond.mumbai.address)
  
  console.log("level 1 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(contractOwner.address, 1))
  console.log("level 1 completed ?: ", await levelLoupeFacet.hasCompletedLevel(contractOwner.address, 1))
  
  console.log("claiming level 1...")
  await level1Facet.claim_l1()

  timeout = new Promise(() => {
    setTimeout(async () => {
      console.log("level 1 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(contractOwner.address, 1))
      console.log("level 1 completed ?: ", await levelLoupeFacet.hasCompletedLevel(contractOwner.address, 1))
    }, 2000)
  }) 
  await timeout
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  level1()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}