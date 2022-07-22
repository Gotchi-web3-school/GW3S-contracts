/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const {readdir, readFile, writeFile} = require('fs').promises
const {levels, secretLevels, hackerLevels} = require("../../helpers/constants.js")
const FILE_PATH = '../../img/common';
const FILE_PATH2 = '../../img/secret';
const FILE_PATH3 = '../../img/hacker';

async function deploySvg () {
  let tx, receipt, common, secret, hacker;

  try {
    svgContracts = JSON.parse(await readFile('./helpers/svgContracts.json', "utf-8"))
    contracts = JSON.parse(await readFile('./helpers/facetsContracts.json', "utf-8"))
    common = await readdir(FILE_PATH)
    secret = await readdir(FILE_PATH2)
    hacker = await readdir(FILE_PATH3)
  } catch (e) {
    console.log(e)
  }

  const SvgFacet = await ethers.getContractAt('SvgFacet', contracts.Diamond.mumbai.address)

  // Deploy svgs for standart level
  for(let i = 0; i < levels.length; i++) {
    console.log(`Deploying ${common[i]}...\n`)
    const svg = await readFile(`${FILE_PATH}/${common[i]}`, "utf-8");
    try {
      tx = await SvgFacet.storeSvg(svg, levels[i], 0)
    } catch (error) {
      tx = await SvgFacet.updateSvg(svg, levels[i], 0)
    }
    receipt = await tx.wait()

    svgContracts.common[`level${levels[i]}`] = {mumbai: receipt.events[1].args[0]}
  }

    // Deploy svgs for secret level
  for(let i = 0; i < secretLevels.length; i++) {
    console.log(`Deploying ${secret[i]}...\n`)
    const svg = await readFile(`${FILE_PATH2}/${secret[i]}`, "utf-8");
    try {
      tx = await SvgFacet.storeSvg(svg, levels[i], 1)
    } catch (error) {
      tx = await SvgFacet.updateSvg(svg, levels[i], 1)
    }
    receipt = await tx.wait()

    svgContracts.secret[`secretLevel${secretLevels[i]}`] = {mumbai: receipt.events[1].args[0]}
  }

  // Deploy svgs for hacker level
  for(let i = 0; i < hackerLevels.length; i++) {
    console.log(`Deploying ${hacker[i]}...\n`)
    const svg = await readFile(`${FILE_PATH3}/${hacker[i]}`, "utf-8");
    try {
      tx = await SvgFacet.storeSvg(svg, levels[i], 2)
    } catch (error) {
      tx = await SvgFacet.updateSvg(svg, levels[i], 2)
    }
    receipt = await tx.wait()

    svgContracts.hacker[`hackerLevel${hackerLevels[i]}`] = {mumbai: receipt.events[1].args[0]}
  }

  console.log("Contracts: ", svgContracts)
  const svgs = JSON.stringify(svgContracts)

  try {
    await writeFile('./helpers/svgContracts.json', svgs)
  } catch (error) {
    console.log(error.message)
    throw error
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
    deploySvg()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deploySvg = deploySvg
