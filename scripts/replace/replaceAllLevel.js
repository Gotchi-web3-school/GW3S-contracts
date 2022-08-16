/* global ethers */
/* eslint prefer-const: "off" */

const { readFile, writeFile } = require("fs").promises
const { getSelectors, getSelector, FacetCutAction } = require('../libraries/diamond.js')
const { deployed } = require("../libraries/deployed.js")
const hardhat = require("hardhat")
const FILE_PATH = './helpers/facetsContracts.json';

async function replaceAllLevel () {
  const accounts = await ethers.getSigners()

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  // deploy facets
  const FacetNames = [
    //'Level0Facet',
    'Level1Facet',
    'Level2Facet',
    'Level3Facet',
    'Level4Facet',
    'Level5Facet',
    'Level6Facet',
    'Level7Facet',
    'Level8Facet',
    'Level9Facet',
    'Level10Facet',
    'Level11Facet',
    'Level12Facet',
    'Level13Facet',
  ]

  const cut = []
  let i = 1;
  for (const FacetName of FacetNames) {

    console.log(`Deploying ${FacetName}...`)
    const Facet = await ethers.getContractFactory(FacetName)
    const facet = await Facet.deploy()
    await facet.deployed()
    
    contracts[`${FacetName}`].mumbai.address = facet.address

    cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Add,
      functionSelectors: [getSelector(`function completeL${i}() external returns (bool)`), getSelector(`function openL${i}Chest() external returns(address[] memory loot, uint[] memory amount)`)]
    })
    i++
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

  writeFile(FILE_PATH, JSON.stringify(contracts))
  return contracts.Diamond.mumbai.address
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  replaceAllLevel()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.replaceAllLevel = replaceAllLevel
