/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile } = require('fs').promises;
const { ethers } = require('hardhat');
const SVG_PATH = '../../img/common/card-01/Front.svg';


async function test () {
  const accounts = await ethers.getSigners()
  const provider = ethers.getDefaultProvider("https://polygon-mainnet.infura.io/v3/d63ccb145caa4670b4db18d68fffdf22")
  const player = accounts[0]
  let tx, receipt

  console.log("Deployer: ", player.address)

  try {
    svg = await readFile(SVG_PATH, "utf-8")
  } catch (e) {
    console.log(e)
  }

  console.log(ethers.utils.toUtf8Bytes(svg).length)
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