/* global ethers */
/* eslint prefer-const: "off" */

const { getSelectors, FacetCutAction } = require('../libraries/diamond.js')
const { deployed } = require("./deployed.js")
const hardhat = require("hardhat")

async function deployERC721Reward () {
    const accounts = await ethers.getSigners()
    const contractOwner = accounts[0]

  // deploy DiamondInit
  // DiamondInit provides a function that is called when the diamond is upgraded to initialize state variables
  // Read about how the diamondCut function works here: https://eips.ethereum.org/EIPS/eip-2575#addingreplacingremoving-functions
  console.log("Deploying InitLevel13...")
  const InitLevel13 = await ethers.getContractFactory('InitLevel13')
  const initLevel13 = await InitLevel13.deploy()
  await initLevel13.deployed()

  deployed("InitLevel13", hardhat.network.name, initLevel13.address)
  
  // deploy facets
  const FacetNames = [
    'Level13Facet',
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
      action: FacetCutAction.Add,
      functionSelectors: getSelectors(facet)
    })
  }

  // upgrade diamond with facets
  console.log('')
  const diamondCut = await ethers.getContractAt('IDiamondCut', contracts.Diamond.mumbai.address)
  let tx
  let receipt
  // call to init function
  let functionCall = initLevel13.interface.encodeFunctionData('init', [cut[0].facetAddress])
  tx = await diamondCut.diamondCut(cut, initLevel13.address, functionCall)
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
    deployERC721Reward()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployERC721Reward = deployERC721Reward
