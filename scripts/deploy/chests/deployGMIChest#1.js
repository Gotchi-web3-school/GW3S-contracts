/* global ethers */
/* eslint prefer-const: "off" */

const { ethers } = require("hardhat");
const hardhat = require("hardhat")
const {writeFile, readFile} = require('fs').promises
const CHEST_PATH = './helpers/chestContracts.json';
const GOTCHIVERSE_POLYGON = "0x1D0360BaC7299C86Ec8E99d0c1C9A95FEfaF2a11"
const GOTCHIVERSE_MUMBAI = "0x726F201A9aB38cD56D60ee392165F1434C4F193D"

async function deployGMIChest () {
  let obj = {}

  try {
    chestContracts = JSON.parse(await readFile(CHEST_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

    console.log(`\nDeploying chest...\n`)
    const Chest = await ethers.getContractFactory('GMIChest')
    const chest = await Chest.deploy("0xd4e42e41FCa01464d36a44ACAb98D2aA1447e8f4", GOTCHIVERSE_POLYGON)
    await chest.deployed()
    console.log("chest deployed !")

    obj[`${hardhat.network.name}`] = chest.address
    chestContracts.GMI["GMIChest#1"] = {...chestContracts.GMI["GMIChest#1"], ...obj}

  try {
    await writeFile(CHEST_PATH, JSON.stringify(chestContracts))
  } catch (error) {
    console.log(error.message)
    throw error
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
    deployGMIChest()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployGMIChest = deployGMIChest
