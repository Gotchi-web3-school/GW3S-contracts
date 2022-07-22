/* global ethers */
/* eslint prefer-const: "off" */

const { lookupService } = require("dns/promises");
const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
const FILE_PATH = './helpers/facetsContracts.json';


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
  const level4Facet = await ethers.getContractAt('Level4Facet', contracts.Diamond.mumbai.address)
  
  console.log("initating level")
  const tx = await level4Facet.initLevel4({gasLimit: 2000000})
  const receipt = await tx.wait()  
  console.log(receipt)
  
  console.log("The game can start !");
  console.log("balance: ", ethers.utils.formatEther(await contractOwner.getBalance()), "MATIC")

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