/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile } = require('fs').promises;
const { ethers } = require('hardhat');
const FILE_PATH = './helpers/facetsContracts.json';
const FRONT_PATH = '../../img/common/card-02/Front.svg';
const BACK_PATH = '../../img/common/card-02/Back.svg';


async function test () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let front, back

  console.log("Deployer: ", player.address)

  try {
    front = await readFile(FRONT_PATH, "utf-8")
    back = await readFile(BACK_PATH, "utf-8")
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }
  console.log("front\n", ethers.utils.toUtf8Bytes(front).length)
  console.log("back\n", ethers.utils.toUtf8Bytes(back).length)

  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  const svgFacet = await ethers.getContractAt("SvgFacet", contracts.Diamond.mumbai.address)

  console.log(`Storing svg level 2...`)
  tx = await svgFacet.updateSvg([front, back], 2, 0)
  receipt = await tx.wait()
  console.log("stored !")

  console.log("finish")
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