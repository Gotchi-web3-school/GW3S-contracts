/* global ethers */
/* eslint prefer-const: "off" */

const { readFile } = require("fs").promises
const { getSelectors, FacetCutAction } = require('../../libraries/diamond.js')
const { deployed } = require("../../libraries/deployed.js")
const hardhat = require("hardhat")
const FILE_PATH = './helpers/facetsContracts.json';

async function deployFactoryFacet () {
  const accounts = await ethers.getSigners()

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  // Deploying initializer
  //--------------------------------------------------------------
  console.log(`Deploying Init router...`)
  const InitRouter = await ethers.getContractFactory("InitRouter")
  const initRouter = await InitRouter.deploy()
  await initRouter.deployed()
  
  deployed("InitRouter", hardhat.network.name, initRouter.address)
  //--------------------------------------------------------------

  const cut = []

  // Deploying factory facet
  //--------------------------------------------------------------
  console.log(`Deploying FactoryFacet...`)
  const FactoryFacet = await ethers.getContractFactory("FactoryFacet")
  const factoryFacet = await FactoryFacet.deploy()
  await factoryFacet.deployed()
  
  deployed("FactoryFacet", hardhat.network.name, factoryFacet.address)
  
  cut.push({
      facetAddress: factoryFacet.address,
      action: FacetCutAction.Add,
      functionSelectors: getSelectors(factoryFacet)
    })
  //--------------------------------------------------------------

  // upgrade diamond with facets
  console.log('')
  const diamondCut = await ethers.getContractAt('IDiamondCut', contracts.Diamond.mumbai.address)
  let tx
  let receipt
  // call to init function
  let functionCall = initRouter.interface.encodeFunctionData('init', [contracts.Router.mumbai.address])
  tx = await diamondCut.diamondCut(cut, initRouter.address, functionCall)
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
    deployFactoryFacet()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployFactoryFacet = deployFactoryFacet
