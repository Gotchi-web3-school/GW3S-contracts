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
  let tx, receipt, svg, key1, key2

  console.log("Deployer: ", player.address)

  try {
    contracts = JSON.parse(await readFile(DIAMOND_FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  const SvgFacet = await ethers.getContractAt("SvgFacet", contracts.Diamond.mumbai.address)
  console.log(SvgFacet)

  const byteStorage = ethers.utils.toUtf8Bytes("diamond.standard.diamond.svgStorage");
  const hashStorage = ethers.utils.keccak256(byteStorage)
  const storage = ethers.utils.hexZeroPad(hashStorage, 32)

  console.log("svg 0: ", await SvgFacet.getLevelRewardSvg(0, 0))

  for (let i = 0; i < levels.length; i++) {
    key1 = ethers.utils.hexZeroPad(levels[i], 32)
    key2 = ethers.utils.hexZeroPad(0, 32)
    console.log("\n\nkey 1: ", key1)
    console.log("key 2: ", key2)
    console.log("position: ", storage)

    const position = ethers.utils.keccak256(ethers.utils.concat([key1, key2, storage]))
    let value = await provider.getStorageAt(contracts.Diamond.mumbai.address, position)
    console.log("\nvalue: ", value)

  }
  const DIAMOND_SVG_STORAGE_POSITION = ethers.utils.keccak256(byteStorage);

  console.log(DIAMOND_SVG_STORAGE_POSITION)

  // console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC");
  // const LevelLoupeFacet = await ethers.getContractAt("LevelLoupeFacet", contracts.Diamond.mumbai.address);
  // const SvgFacet = await ethers.getContractAt("SvgFacet", contracts.Diamond.mumbai.address);

  // console.log(await LevelLoupeFacet.getAddress(0));
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