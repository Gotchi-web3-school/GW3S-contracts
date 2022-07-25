/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile } = require('fs').promises;
const { ethers } = require('hardhat');
const {levels, secretLevels, hackerLevels} = require("../helpers/constants.js");
const DIAMOND_FILE_PATH = './helpers/facetsContracts.json';


async function test () {
  const accounts = await ethers.getSigners()
  const provider = ethers.getDefaultProvider("https://polygon-mainnet.infura.io/v3/d63ccb145caa4670b4db18d68fffdf22")
  const player = accounts[0]
  let tx, receipt

  console.log("Deployer: ", player.address)

  console.log("Deploy test...")
  const Test = await ethers.getContractFactory("Test")
  const test = await Test.deploy()
  await test.deployed()
  
  console.log("Store value...")
  tx = await test.callStatic.store(10)
  console.log(tx)
  console.log(receipt.logs)
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