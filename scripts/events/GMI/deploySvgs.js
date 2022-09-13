/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat');
const { exit } = require("process");
const SVG_PATH = './helpers/svgContracts.json';
const FILE_PATH = './helpers/utilsContracts.json';

async function deploySvg () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, svg

  // For test fix size

  console.log("Deployer: ", player.address)
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")
  try {
    contracts = JSON.parse(await readFile(SVG_PATH, "utf-8"))
    utils = JSON.parse(await readFile(FILE_PATH, "utf-8"))
    } catch (e) {
        console.log(e)
        exit(1)
    }

const StoreSvg = await ethers.getContractAt("ISvgStore", utils.svgDeployer[`${hardhat.network.name}`])

const svgs = [
  // svgFront = await readFile(`../../img/events/GMI artist's summit/Front.svg`, "utf-8"),
  svgBack = await readFile(`../../img/events/GMI artist's summit/Back.svg`, "utf-8"),
  // svgLeft = await readFile(`../../img/common/left-side.svg`, "utf-8"),
  // svgRight = await readFile(`../../img/common/right-side.svg`, "utf-8")
]

try {
    for (let i = 0; i < svgs.length; i++) {
        if (ethers.utils.toUtf8Bytes(svgs[i]).length > 24576) {
            console.log("Svg too big to be deployed")
            console.log("svg size: ", ethers.utils.toUtf8Bytes(svgs[i]).length)
        } else {
            console.log(`Deploying ${i}`)
            svgAddress = await StoreSvg.callStatic.deploySvg(svgs[i])
            tx = await StoreSvg.deploySvg(svgs[i])
            await tx.wait()
        
            console.log("SvgAddress: ", svgAddress, "\n")
        }
    
      }
    } catch (error) {
      console.log(error)
      console.log('')
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