/* global ethers */
/* eslint prefer-const: "off" */

const { readFile } = require("fs").promises
const { getSelectors, FacetCutAction } = require('../libraries/diamond.js')
const { deployed } = require("./deployed.js")
const hardhat = require("hardhat")
const FILE_PATH = './deployed.json';

async function deployLevelLoupeFacet (diamondAddress) {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]
  const routerAddress = "0x2dc82984e9DaBA3Cb9a97887cCFa0311937cF9D6"

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  const cut = []
  
  console.log(`Deploying InitRouter...`)
  const Router = await ethers.getContractFactory("InitRouter")
  const initRouter = await Router.deploy()
  await initRouter.deployed()
  console.log("init router deployed")
  
  // Deploying LevelLoupeFacet
  //--------------------------------------------------------------
  console.log(`Deploying LevelLoupeFacet...`)
  const Facet = await ethers.getContractFactory("LevelLoupeFacet")
  const facet = await Facet.deploy()
  await facet.deployed()
  
  deployed("LevelLoupeFacet", hardhat.network.name, facet.address)
  
  cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Replace,
      functionSelectors: getSelectors(facet)
    })
  //--------------------------------------------------------------


  // upgrade diamond with facets
  console.log('')
  const diamondCut = await ethers.getContractAt('IDiamondCut', diamondAddress)
  let tx
  let receipt
  // call to init function
  let functionCall = initRouter.interface.encodeFunctionData('init', [routerAddress])
  tx = await diamondCut.diamondCut(cut, initRouter.address, functionCall)
  console.log('Diamond cut tx: ', tx.hash)
  receipt = await tx.wait()
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
  console.log('Completed diamond cut')
  return cut[0].facetAddress
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  const diamondAddress = "0x0CCB703023710Ee12Ad03be71A9C24c92998C505"
  deployLevelLoupeFacet(diamondAddress)
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployLevelLoupeFacet = deployLevelLoupeFacet
