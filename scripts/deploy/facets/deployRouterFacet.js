/* global ethers */
/* eslint prefer-const: "off" */
const { readFile } = require("fs").promises
const { getSelectors, FacetCutAction } = require('../../libraries/diamond.js')
const { deployed } = require("../../libraries/deployed.js")
const hardhat = require("hardhat")
const FILE_PATH = './helpers/facetsContracts.json';

async function deployRouterFacet () {
  const cut = [];
  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  console.log("Deploying router...")
  const Router = await ethers.getContractFactory("RouterFacet")
  const facet = await Router.deploy()
  await facet.deployed()
  console.log("Deployed !")

  deployed("RouterFacet", hardhat.network.name, facet.address)

  cut.push({
    facetAddress: facet.address,
    action: FacetCutAction.Add,
    functionSelectors: getSelectors(facet)
  })

  // upgrade diamond with facets
  console.log('')
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
  return cut[0].facetAddress
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  deployRouterFacet()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployRouterFacet = deployRouterFacet
