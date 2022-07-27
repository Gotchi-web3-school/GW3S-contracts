/* global ethers */
/* eslint prefer-const: "off" */
const {readFile} = require('fs').promises
const { deployDiamond} = require("../deployDiamond.js")
const { getSelectors, getSelector, FacetCutAction } = require('../../libraries/diamond.js')
const { deployed } = require("../../libraries/deployed.js")
const hardhat = require("hardhat");
const { ethers } = require('hardhat');
const FILE_PATH = './helpers/facetsContracts.json';
const TOKENS_NAME = ["level6 GHST", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI", "level6 DAI"];
const TOKENS_SYMBOL = ["GHST", "DAI", "DAI", "DAI", "DAI", "DAI", "DAI"];
const TOKEN_ADDRESS = []
const MAX = 100000000000 * 10 ** 18;

async function deployLevel6Facet () {
  let tx, receipt
  let contracts

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }
  
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

    const funcSelect = getSelector("function getPair(address token0, address token1) public returns(address pair)")

    cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Add,
      functionSelectors: [funcSelect]
    })
  

  // upgrade diamond with facets
  console.log('')
  const diamondCut = await ethers.getContractAt('IDiamondCut', contracts.Diamond.mumbai.address)
  // call to init function
  tx = await diamondCut.diamondCut(cut, "0x0000000000000000000000000000000000000000", [])
  //console.log('Diamond cut tx: ', tx.hash)
  receipt = await tx.wait()
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
  console.log('Completed diamond cut')
  return cut[0].facetAddress
}

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
