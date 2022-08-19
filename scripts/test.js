/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile } = require('fs').promises;
const { ethers } = require('hardhat');
const FILE_PATH = './helpers/facetsContracts.json';


async function test () {
  const accounts = await ethers.getSigners()
  const provider = ethers.getDefaultProvider("https://polygon-mainnet.infura.io/v3/d63ccb145caa4670b4db18d68fffdf22")
  const player = accounts[0]
  let tx, receipt
  let loading = false
  
  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  console.log("Deployer: ", player.address)
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  const Level0Facet = await ethers.getContractAt("Level0Facet", contracts.Diamond.mumbai.address)

  loading = true
  tx = await Level0Facet.openL0Chest()
  let playing = playSound()
  let playingnot = notPlaySound()
  receipt = await tx.wait()
  loading = false
  await playing
  await playingnot

  console.log("finished")
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