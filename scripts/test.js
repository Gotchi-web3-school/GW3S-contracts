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

  console.log()
  // try {
  //   contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  // } catch (e) {
  //   console.log(e)
  // }

  // console.log("Deployer: ", player.address)
  // console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")

  // const LevelLoupeFacet = await ethers.getContractAt("LevelLoupeFacet", contracts.Diamond.mumbai.address)
  // const Level12Facet = await ethers.getContractAt("Level12Facet", contracts.Diamond.mumbai.address)
  // instance = await LevelLoupeFacet.getLevelInstanceByAddress("0x6fA1e885743fc06c3f04ec3fc179769795FC93AB", 12)
  // console.log("instance", instance)
  // factory = await LevelLoupeFacet.getFactoryLevel(12, 0)
  // factory1 = await LevelLoupeFacet.getFactoryLevel(12, 1)
  // console.log("factory :", factory)
  // console.log("factory1 :", factory1)
  // tx = await Level12Facet.initLevel12()
  


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