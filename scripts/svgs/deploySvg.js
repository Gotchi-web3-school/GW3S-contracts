/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat');
const { exit } = require("process");
const {metadatas} = require("../../helpers/constants.js");
const SVG_PATH = './helpers/svgContracts.json';
const FILE_PATH = './helpers/facetsContracts.json';

async function test () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, svg

  // For test fix size

  console.log("Deployer: ", player.address)
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  try {
    contracts = JSON.parse(await readFile(SVG_PATH, "utf-8"))
    diamond = JSON.parse(await readFile(FILE_PATH, "utf-8"))
    } catch (e) {
        console.log(e)
        exit(1)
    }

const SvgFacet = await ethers.getContractAt("SvgFacet", diamond.Diamond.mumbai.address)

try {
    for (let i = 0; i < 3; i++) {
        svgFront = await readFile(`../../img/common/card-0${i}/Front.svg`, "utf-8")
        svgBack = await readFile(`../../img/common/card-0${i}/Back.svg`, "utf-8")
        
        
        if (ethers.utils.toUtf8Bytes(svgFront).length > 24576 || ethers.utils.toUtf8Bytes(svgBack).length > 24576) {
            console.log("Svg too big to be deployed")
            console.log("svg size: ", ethers.utils.toUtf8Bytes(svg).length)
        } else {
            console.log("Deploying front...")
            svgFrontAddress = await SvgFacet.callStatic.deploySvg(svgFront)
            tx = await SvgFacet.deploySvg(svgFront)
            await tx.wait()

            svgBackAddress = await SvgFacet.callStatic.deploySvg(svgBack)
            console.log("Deploying back...")
            tx = await SvgFacet.deploySvg(svgBack)
            await tx.wait()
        
            console.log("update the file contracts obj...\n")
            let mumbai = {front: svgFrontAddress, back: svgBackAddress}
            let obj = {mumbai}
            contracts.common[`level${i}`] = obj;
        }
    
            console.log(contracts)
        }
    } catch (error) {
      console.log(error)
      console.log('')
    }

  const obj = JSON.stringify(contracts)

  try {
    await writeFile(SVG_PATH, obj);
  } catch (e) {
    console.log(e.message);
    throw e;
  }
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