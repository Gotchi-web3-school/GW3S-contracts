/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile } = require('fs').promises;
const { ethers } = require('hardhat')
const FILE_PATH = './deployed.json';


async function level7 () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let tx, receipt

  console.log("Player: ", player.address)

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }

  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")

  const levelLoupeFacet = await ethers.getContractAt("LevelLoupeFacet", contracts.Diamond.mumbai.address)
  const routerAddress = await levelLoupeFacet.getRouter()
  const IRouter = await ethers.getContractAt("IRouter", routerAddress)  
  const ILevel7Facet = await ethers.getContractAt("Level7Facet", contracts.Diamond.mumbai.address)
  
  
  // STEP 0 Init
  console.log("Init level...")
  tx = await ILevel7Facet.initLevel7()
  receipt = await tx.wait()
  console.log("level deployed at :", await levelLoupeFacet.getLevelInstanceByAddress(player.address, 7))
  
 console.log("\nLevel start !\n")
 
 const Ilevel7Instance = await ethers.getContractAt('ILevel7Instance', await levelLoupeFacet.getLevelInstanceByAddress(player.address, 7))
 const IGHST = await ethers.getContractAt('@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20', await Ilevel7Instance.tokens(0))
 const IDAI = await ethers.getContractAt('@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20', await Ilevel7Instance.tokens(1))
  
  // STEP 1 approve
  console.log("Approving token 0...")
  tx = await IGHST.approve(routerAddress, ethers.utils.parseEther("100"))
  receipt = await tx.wait()
  console.log("GHST approved !\n")
  
  console.log("Approving token 1...")
  tx = await IDAI.approve(routerAddress, ethers.utils.parseEther("100"))
  receipt = await tx.wait()
  console.log("DAI approved !\n")
  
  
  console.log("Adding liquidity...")
  const factoryAddress = await levelLoupeFacet.getFactoryByPlayer(player.address)
  console.log("Factory address: ", factoryAddress)
  console.log("GHST address: ", IGHST.address)
  console.log("DAI address: ", IDAI.address)
  // STEP 2 add liquidity
  tx = await IRouter.addLiquidity(IGHST.address, IDAI.address, 10000, 10000, 10000, 10000, player.address, Date.now() + 100000000, factoryAddress)
  receipt = await tx.wait()
  console.log("Liquidity added !")
  
  console.log("Completing level...")
  // STEP 3 complete level
  tx = await ILevel7Facet.complete_l7()
  receipt = await tx.wait()
  console.log("Level completed !")
  console.log("")
  
  
  console.log("Completed ? ", await levelLoupeFacet.hasCompletedLevel(player.address, 7))
  
  console.log("")
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  level7()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}