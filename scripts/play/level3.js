/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { readFile, writeFile } = require('fs').promises;
const { ethers } = require('hardhat')
const FILE_PATH = './helpers/facetsContracts.json';


async function level3 () {
  const accounts = await ethers.getSigners()
  const player = accounts[0]
  const provider = ethers.getDefaultProvider()

  let instance, tx, receipt

  console.log("Player:", player.address)
  console.log("balance: ", ethers.utils.formatEther(await player.getBalance()), "MATIC")

  try {
    contracts = JSON.parse(await readFile(FILE_PATH, "utf-8"))
  } catch (e) {
    console.log(e)
  }


  // attach DiamondLoupeFacet
  const level3Facet = await ethers.getContractAt('Level3Facet', contracts.Diamond.mumbai.address)
  const levelLoupeFacet = await ethers.getContractAt('ILevelLoupeFacet', contracts.Diamond.mumbai.address)
  const IRouter = await ethers.getContractAt("IRouter", contracts.Diamond.mumbai.address)

  console.log("\nlevel 3 completed ?: ", await levelLoupeFacet.hasCompletedLevel(player.address, 3))
  console.log("level 3 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(player.address, 3))

  console.log("\nLevel initiation...")
  tx = await level3Facet.initLevel3()
  receipt = await tx.wait()
  
  instance = await levelLoupeFacet.getLevelInstanceByAddress(player.address, 3);
  const ILevel3Instance = await ethers.getContractAt('ILevel3Instance', instance);
  
  console.log('')
  
  let tokens = []
  let symbols = []
  for(let i = 0; i < 2; i++){
    symbols.push(await ILevel3Instance.TOKENS_SYMBOL(i));
    tokens.push(await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", await ILevel3Instance.tokens(i)));
    
    console.log(`balance of ${symbols[i]}: ${ethers.utils.formatEther(await tokens[i].balanceOf(player.address))}`)
  }
  
  console.log('')
  
  console.log(`Approving ${symbols[0]}...`)
  tx = await tokens[0].approve(IRouter.address, ethers.utils.parseEther("10"))
  receipt = await tx.wait()
  
  // Swap context
  const IPair = await ethers.getContractAt("IPair", await ILevel3Instance.callStatic.getPair())
  const [reserve0, reserve1] = await IPair.getReserves()
  console.log("reserve0:", reserve0)
  console.log("reserve1:", reserve1)
  const amountIn = ethers.utils.parseEther("10")
  console.log("Amount in: ", amountIn)
  const amountOutMin = await IRouter.getAmountOut(amountIn, reserve0, reserve1)
  console.log("Amount out: ", amountOutMin)
  const path = [tokens[0].address, tokens[1].address]
  console.log("Path ", path)
  // Get the current timestamp
  const blockNumber = await ethers.provider.getBlockNumber();
  const {timestamp} = await ethers.provider.getBlock(blockNumber)
  const deadLine = timestamp + 3000
  const factory = await ILevel3Instance.factory()
  
  console.log("Swap DAI token for GHST...")
  tx = await IRouter.swapExactTokensForTokens(
    amountIn,
    amountOutMin,
    path,
    player.address,
    deadLine,
    factory
  )
  receipt = await tx.wait()
  
  console.log(`balance of ${symbols[0]}: ${ethers.utils.formatEther(await tokens[0].balanceOf(player.address))}`)
  console.log(`balance of ${symbols[1]}: ${ethers.utils.formatEther(await tokens[1].balanceOf(player.address))}`)

  console.log("\nCompleting level...")
  tx = await level3Facet.complete_l3()
  receipt = await tx.wait() 

  console.log("\nclaiming level 3...")
  tx = await level3Facet.claim_l3()
  receipt = await tx.wait()


  console.log("\nlevel 3 claimed ?: ", await levelLoupeFacet.hasClaimedLevel(player.address, 3))
  console.log("level 3 completed ?: ", await levelLoupeFacet.hasCompletedLevel(player.address, 3))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  level3()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.level3 = level3