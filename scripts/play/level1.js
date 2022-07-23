/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
const FILE_PATH = './helpers/facetsContracts.json';


async function level1 () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]
  let tx, receipt;

  console.log("Player: ", contractOwner.address)

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

  console.log("\nLevel initiation...")
  tx = await level1Facet.initLevel1()
  receipt = await tx.wait() 
  
  console.log("\nCompleting level...")
  tx = await level1Facet.complete_l1()
  receipt = await tx.wait() 


  console.log("\nclaiming level 1...")
  tx = await level1Facet.claim_l1()
  receipt = await tx.wait() 

  console.log("\nlevel 1 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(contractOwner.address, 1))
  console.log("level 1 completed ?: ", await levelLoupeFacet.hasCompletedLevel(contractOwner.address, 1))
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