/* global ethers */
/* eslint prefer-const: "off" */
const {readFile} = require('fs').promises
const { deployDiamond} = require("../deployDiamond.js")
const { getSelectors, FacetCutAction } = require('../../libraries/diamond.js')
const { deployed } = require("../../libraries/deployed.js")
const hardhat = require("hardhat");
const { ethers } = require('hardhat');
const FILE_PATH = './helpers/facetsContracts.json';
const TOKENS_NAME = ["level6 GHST", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI"];
const TOKENS_SYMBOL = ["GHST", "DAI", "DAI", "DAI", "DAI", "DAI", "DAI"];
const TOKEN_ADDRESS = []
const MAX = 100000000000 * 10 ** 18;

async function deployLevel6Facet () {
  let tx
  let contracts

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }


  // deploy DiamondInit
  // DiamondInit provides a function that is called when the diamond is upgraded to initialize state variables
  // Read about how the diamondCut function works here: https://eips.ethereum.org/EIPS/eip-2575#addingreplacingremoving-functions
  console.log("Deploying InitLevel6...")
  const InitLevel6 = await ethers.getContractFactory('InitLevel6')
  const initLevel6 = await InitLevel6.deploy()
  await initLevel6.deployed()

  deployed("InitLevel6", hardhat.network.name, initLevel6.address)
  
  // deploy facets
  const FacetNames = [
    'Level6Facet',
  ]
  const cut = []
  for (const FacetName of FacetNames) {
    console.log(`Deploying ${FacetName}...`)
    const Facet = await ethers.getContractFactory(FacetName)
    const facet = await Facet.deploy()
    await facet.deployed()
    
    deployed(FacetName, hardhat.network.name, facet.address)

    cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Replace,
      functionSelectors: getSelectors(facet)
    })
  }

  // upgrade diamond with facets
  console.log('')
  const diamondCut = await ethers.getContractAt('IDiamondCut', contracts.Diamond.mumbai.address)
  let receipt
  // call to init function
  let functionCall = initLevel6.interface.encodeFunctionData('init', [cut[0].facetAddress, TOKEN_ADDRESS, factoryAddress])
  console.log(functionCall)
  tx = await diamondCut.diamondCut(cut, initLevel6.address, functionCall)
  //console.log('Diamond cut tx: ', tx.hash)
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
    deployLevel6Facet()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployLevel6Facet = deployLevel6Facet
