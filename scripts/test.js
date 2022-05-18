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
  /*
  const Level1Facet = await ethers.getContractFactory("Level1Facet")
  const DiamondLoupeFacet = await ethers.getContractAt("DiamondLoupeFacet", contracts.DiamondLoupeFacet.mumbai.address)
  const sig = Level1Facet.interface.s
  console.log(await DiamondLoupeFacet.facetAddress())
  */

  const tx = await contractOwner.sendTransaction({to: "0xf7D3081BDb689661f7714660EB26917b19Aba320", value: ethers.utils.parseEther('0.4')})
  await tx.wait()

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
