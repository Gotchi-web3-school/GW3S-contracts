/* global ethers */

const hardhat = require("hardhat")
//onst { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
const { getSelectors, getSelector, getAddress, facets} = require("./libraries/diamond");
//const FILE_PATH = './deployed.json';

async function deployDiamond () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]
  
  console.log( "Deploying factory test !")
  const Test = await ethers.getContractFactory("FactoryTest")
  const test = await Test.deploy()
  await test.deployed()
  console.log( "Deployed !")
  console.log(test.address)
  console.log('')
  
  console.log( "Deploying aa new facto !")
  const tx = await test.deployFactory(contractOwner.address)
  const receipt = await tx.wait()
  console.log(receipt.logs)
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
