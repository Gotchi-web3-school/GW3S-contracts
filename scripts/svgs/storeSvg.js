/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile } = require('fs').promises;
const { ethers } = require('hardhat');
const FILE_PATH = './deployed.json';


async function test () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, receipt, svg

  console.log("Deployer: ", player.address)

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  const LevelLoupeFacet = await ethers.getContractAt("LevelLoupeFacet", contracts.Diamond.mumbai.address)

  console.log(await LevelLoupeFacet.getAddress(0))

  /*
  const svgFacet = await ethers.getContractAt("ISvgFacet", contracts.Diamond.mumbai.address)
  
  svg = await readFile("../../img/secret/level-12s.svg", "utf-8");
  console.log(`Storing level-12s.svg...`)
  tx = await svgFacet.updateSvg(svg, 13, 1)
  receipt = await tx.wait()
  console.log("stored !")

  console.log("finish")
  */
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