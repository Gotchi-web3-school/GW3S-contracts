/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
const FILE_PATH = './helpers/facetsContracts.json';


async function level2 () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  let instance, tx, receipt

  console.log("Player:", player.address)
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }


  // attach DiamondLoupeFacet
  const level2Facet = await ethers.getContractAt('Level2Facet', contracts.Diamond.mumbai.address)
  const levelLoupeFacet = await ethers.getContractAt('ILevelLoupeFacet', contracts.Diamond.mumbai.address)
  
  console.log("\nlevel 2 completed ?: ", await levelLoupeFacet.hasCompletedLevel(player.address, 2))
  console.log("level 2 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(player.address, 2))
  console.log("\nLevel initiation...")
  tx = await level2Facet.initLevel2()
  receipt = await tx.wait()

  instance = await levelLoupeFacet.getLevelInstanceByAddress(player.address, 2);
  const ILevel2Instance = await ethers.getContractAt('ILevel2Instance', instance);

  console.log('')
  
  let tokens = []
  let symbols = []
  for(let i = 0; i < 4; i++){
    symbols.push(await ILevel2Instance.TOKENS_SYMBOL(i));
    tokens.push(await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", await ILevel2Instance.tokens(i)));
    
    console.log(`balance of ${symbols[i]}: ${ethers.utils.formatEther(await tokens[i].balanceOf(player.address))}`)
  }
  
  console.log('')

  for(let i = 0; i < 4; i++) {
    console.log(`Approving ${symbols[i]}...`)
    
    tx = await tokens[i].approve(ILevel2Instance.address, ethers.utils.parseEther("10"))
  }
  
  console.log("\nShip tokens...")
  tx = await ILevel2Instance.shipTokens();
  receipt = await tx.wait()

  console.log("\nCompleting level...")
  tx = await level2Facet.complete_l2()
  receipt = await tx.wait() 

  console.log("\nclaiming level 2...")
  tx = await level2Facet.claim_l2()
  receipt = await tx.wait()


  console.log("\nlevel 2 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(player.address, 2))
  console.log("level 2 completed ?: ", await levelLoupeFacet.hasCompletedLevel(player.address, 2))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  level2()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}