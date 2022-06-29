/* global ethers */

const hardhat = require("hardhat")
//onst { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
//const FILE_PATH = './deployed.json';

async function deployDiamond () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]

  console.log("address of user: ", contractOwner.address)

  const hash = ethers.utils.keccak256(contractOwner.address)
  console.log("hash: ", hash)

  const sig = await contractOwner.signMessage("hello")
  console.log(sig)

  const recoveredAddress = ethers.utils.verifyMessage("hello", sig)
  console.log("Recover address: ", recoveredAddress)
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
