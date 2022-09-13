/* global ethers */
/* eslint prefer-const: "off" */

const { readFile } = require("fs").promises
const { getSelectors, FacetCutAction } = require('../libraries/diamond.js')
const { deployed } = require("../libraries/deployed.js")
const hardhat = require("hardhat")
const FILE_PATH = './helpers/facetsContracts.json';
const WETH_MUMBAI_ADDRESS = "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889"

async function deployDiamond () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  // deploy DiamondInit
  // DiamondInit provides a function that is called when the diamond is upgraded to initialize state variables
  // Read about how the diamondCut function works here: https://eips.ethereum.org/EIPS/eip-2535#addingreplacingremoving-functions
  // console.log("Deploy InitAMMFacet...")
  // const InitAMMFacet = await ethers.getContractFactory('InitAMMFacet')
  // const initAMMFacet = await InitAMMFacet.deploy()
  // await initAMMFacet.deployed()
  // console.log("InitAMMFacet deployed !")

  // deploy facets
  const FacetNames = [
    'RouterFacet',
  ]
  const cut = []
  for (const FacetName of FacetNames) {
    console.log(`Deploying ${FacetName}...`)
    const Facet = await ethers.getContractFactory(FacetName)
    const facet = await Facet.deploy()
    await facet.deployed()
    
    deployed("RouterFacet", hardhat.network.name, facet.address)

    cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Replace,
      functionSelectors: getSelectors(facet)
    })
  }

  // upgrade diamond with facets
  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', contracts.Diamond.mumbai.address)
  let tx
  let receipt
  // call to init function
  // let functionCall = initAMMFacet.interface.encodeFunctionData('init', [WETH_MUMBAI_ADDRESS, cut[0].facetAddress])
  // console.log(functionCall)
  // tx = await diamondCut.diamondCut(cut, initAMMFacet.address, functionCall)
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
  deployDiamond()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployDiamond = deployDiamond
