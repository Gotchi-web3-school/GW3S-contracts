/* global ethers */
/* eslint prefer-const: "off" */

const { readFile } = require("fs").promises
const { getSelector, getSelectors, FacetCutAction } = require('../libraries/diamond.js')
const { deployed } = require("../libraries/deployed.js")
const hardhat = require("hardhat")
const FILE_PATH = './helpers/facetsContracts.json';

async function replaceSvgFacet() {
  const accounts = await ethers.getSigners()

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  // deploy DiamondInit
  // DiamondInit provides a function that is called when the diamond is upgraded to initialize state variables
  // Read about how the diamondCut function works here: https://eips.ethereum.org/EIPS/eip-2535#addingreplacingremoving-functions

  // deploy facets
  const FacetNames = [
    'SvgFacet',
  ]
  const cut = []
  for (const FacetName of FacetNames) {
    // console.log(`Deploying ${FacetName}...`)
    // const Facet = await ethers.getContractFactory(FacetName)
    // const facet = await Facet.deploy()
    // await facet.deployed()
    
    // deployed(FacetName, hardhat.network.name, facet.address)

    cut.push({
      facetAddress: "0x0000000000000000000000000000000000000000",
      action: FacetCutAction.Remove,
      functionSelectors: [getSelector("function getSvgLevelReward(uint256 levelId, uint256 _type) external view returns(struct)")]
    })
  }

  // upgrade diamond with facets
  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', contracts.Diamond.mumbai.address)
  let tx
  let receipt
  // call to init function
  tx = await diamondCut.diamondCut(cut, "0x0000000000000000000000000000000000000000", [])
  console.log('Diamond cut tx: ', tx.hash)
  receipt = await tx.wait()
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
  console.log('Completed diamond cut')
  return contracts.Diamond.mumbai.address
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
    replaceSvgFacet()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.replaceSvgFacet = replaceSvgFacet
