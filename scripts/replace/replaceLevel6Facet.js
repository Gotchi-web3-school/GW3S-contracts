/* global ethers */
/* eslint prefer-const: "off" */

const { readFile } = require("fs").promises
const { getSelectors, getSelector, FacetCutAction } = require('../libraries/diamond.js')
const { deployed } = require("../libraries/deployed.js")
const hardhat = require("hardhat");
const { ethers } = require("hardhat");
const FILE_PATH = './helpers/facetsContracts.json';

async function deployDiamond () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]
  let tx, receipt
  let tokens = []

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

//   const Router = await ethers.getContractFactory("UniswapV2Router01")
//   const Token = await ethers.getContractFactory("contracts/GW3S/AMM/facets/TokenFacet.sol:Token")
//   const ILevel6 = await ethers.getContractAt("ILevel6", contracts.Diamond.mumbai.address)

//   const factory = await ILevel6.getFactory()
//   const WMATIC = "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889"

//   console.log("Deploying router...")
//   const router = await Router.deploy(factory, WMATIC)
//   await router.deployed()
//   console.log("deployed succesffully")



// GHST = await Token.deploy("level6 GHST", "GHST", contractOwner.address)
// await GHST.deployed()
// tokens.push(GHST.address)
// console.log(tokens)
// console.log("deployed ghst successfully")

// // Mint 1000000 GHST
// console.log("mint 1 billion ghst...")
// tx = await GHST.mint(contractOwner.address, ethers.utils.parseEther("6000000000"))
// await tx.wait()
// console.log("Minted ghst successfully")

// // Approve diamond
// console.log("Approve diamond...")
// tx = await GHST.approve(router.address, ethers.utils.parseEther("6000000000"))
// await tx.wait()
// console.log("Approved ghst successfully")
// ////////////////////////////////////////////////////////////

// for (let i = 0; i < 6; i++) {
// // Deploy DAI token
// console.log("deploying DAI...")
// DAI = await Token.deploy("level6 DAI", "DAI", contractOwner.address)
// await DAI.deployed()
// tokens.push(DAI.address)
// console.log("deployed DAI successfully")

// // Mint 1000000 GHST
// console.log("mint 1 billion ghst...")
// tx = await DAI.mint(contractOwner.address, ethers.utils.parseEther("1000000000"))
// await tx.wait()
// console.log("Minted ghst successfully")

// // Approve diamond
// console.log("Approve diamond...")
// tx = await DAI.approve(router.address, ethers.utils.parseEther("1000000000"))
// await tx.wait()
// console.log("Approved diamond successfully")

// // Add liquidity to factory level 6
// // get factory level 6
// console.log("Add liquidity to diamond factory")
// tx = await router.addLiquidity(
//   GHST.address,
//   DAI.address,
//   ethers.utils.parseEther("1000000000"),
//   ethers.utils.parseEther("1000000000"),
//   ethers.utils.parseEther("1000000000"),
//   ethers.utils.parseEther("1000000000"),
//   contracts.Diamond.mumbai.address,
//   27755156 + 10000000000000,
// )
// await tx.wait()
// console.log("liquidity added successfully")

// console.log("Transfering ownership of ghst...")
// tx = await DAI.transferOwnership(contracts.Diamond.mumbai.address)
// await tx.wait()
// console.log("Succesffull")
// }


// // Transfert ownership of the both tokens to diamond
// console.log("Transfering ownership of ghst...")
// tx = await GHST.transferOwnership(contracts.Diamond.mumbai.address)
// await tx.wait()
// console.log("Succesffull")


  // deploy DiamondInit
  // DiamondInit provides a function that is called when the diamond is upgraded to initialize state variables
  // Read about how the diamondCut function works here: https://eips.ethereum.org/EIPS/eip-2535#addingreplacingremoving-functions

  console.log("deploy InitLevel6...")
  const InitLevel6 = await ethers.getContractFactory('InitLevel6')
  const init = await InitLevel6.deploy()

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
    
    deployed("Level6Facet", hardhat.network.name, facet.address)

    cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Replace,
      functionSelectors: getSelectors(facet)
    })
  }
console.log(tokens)
  // upgrade diamond with facets
  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', contracts.Diamond.mumbai.address)
  let functionCall = init.interface.encodeFunctionData('init', [['0x0838ba07e4847692d8cF6980Cbb2a4451B92c9e7',
  '0x76b77851A8326D825027621ecbd9B4f0c8472282',
  '0x86197f1E6B300334C3a1ad9360a9538d10228100',
  '0x6959e08e78D6fb03cd7B08200958496BB01b176D',
  '0x512eFDe9A029E4Adc70d7838f068BA06E6c6178D',
  '0xC63d1897c87863b60F78697CAF6685Cb78e51c7F',
  '0x519d005567255824e059645BCeCba285Bf8A2B7a']])
  console.log(functionCall)
  tx = await diamondCut.diamondCut(cut, init.address, functionCall)
  //tx = await diamondCut.diamondCut(cut, "0x0000000000000000000000000000000000000000", [])
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
