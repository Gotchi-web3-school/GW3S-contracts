/* global describe it before ethers */

const {
    getSelectors,
    FacetCutAction,
    removeSelectors,
    findAddressPositionInFacets
  } = require('../scripts/libraries/diamond.js')
  const { ethers } = require('hardhat')
  const {formatEther, parseEther} = ethers.utils
  
  const { deployDiamond } = require('../scripts/deploy/deployDiamond.js')
  const { deployLevelLoupeFacet } = require('../scripts/deploy/deployLevelLoupeFacet.js')
  const { deployFactoryFacets } = require('../scripts/deploy/deployFactoryFacets.js')
  const { deployRouterFacet, deployRouter } = require('../scripts/deploy/deployRouter.js')
  const { deployLevel4 } = require('../scripts/deploy/deployLevel4Facet.js')
  const { expect } = require('chai')
  
describe("Level 4", () => {
    let diamondAddress, level4Address, factoryFacetsAddress, instanceAddress, routerAddress
    let diamondCutFacet, diamondLoupeFacet, ownershipFacet, level4Facet, levelLoupeFacet
    let player1, player2, player4
    let tx, receipt
    let IGHST, IDAI, IERC20, IROUTER, IFACTORY, ILevel4Instance
    let player;
    let levelId;
    let tokens = []
    let Loupe
    
    before(async function () {
        
        [player1, player2, player4] = await ethers.getSigners()
        diamondAddress = await deployDiamond()
        routerAddress = await deployRouter()
        levelLoupeAddress = await deployLevelLoupeFacet(diamondAddress)
        factoryFacetsAddress = await deployFactoryFacets(routerAddress, diamondAddress)
        level4Address = await deployLevel4(diamondAddress)
        
        diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
        diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
        ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
        levelLoupeFacet = await ethers.getContractAt('LevelLoupeFacet', diamondAddress)
        level4Facet = await ethers.getContractAt('Level4Facet', diamondAddress)
    })
    
    describe("init", () => {
        it('should return the address of level4Facet', async () => {
            const address = await levelLoupeFacet.getAddress(4)
            expect(address).to.equal(level4Address)
        })
        it('should return false on "Completed & reward"', async () => {
            const isCompleted = await levelLoupeFacet.hasCompletedLevel(player1.address, 4)
            const isClaimedLevel = await levelLoupeFacet.hasClaimedLevel(player1.address, 4)
            
            expect(isCompleted).to.equal(false, "isCompleted failed")
            expect(isClaimedLevel).to.equal(false, "isClaimedLevel failed")
        })
        it('should instanciate a new level 4', async () => {
            await level4Facet.initLevel4({gasLimit: 12450000})
        })
    })
    
    describe("play", () => {
        
        before(async function () {
            tx = await level4Facet.initLevel()
            receipt = await tx.wait()
            deployedInstance = receipt.events.forEach(element =>{ 
                if (element.event === "DeployedInstance") {
                    instanceAddress = element.args.instance
                    player = element.args.player
                    levelId = element.args.level
                }
            })
            ILevel4Instance = await ethers.getContractAt("ILevel4Instance", instanceAddress)
            for(let i = 0; i < 2; i++) {
                tokens.push(await ILevel4Instance.tokens(i))
            }
        })
  
        it('should return the address of the player', async () => {
            expect(await ILevel4Instance.player()).to.equal(player)
        })
        it('should return the id of the level (4)', async () => {
            expect(await levelId).to.equal(4)
        })
        it('should return the tokens SYMBOL', async () => {
            let tokens = ["DAI", "GHST"]
            for(let i = 0; i < 2; i++) {
                expect(await ILevel4Instance.TOKENS_SYMBOL(i)).to.equal(tokens[i])
            }
        })
        it('should start game with player having 10 DAI & 0 GHST', async () => {
            for(let i = 0; i < 2; i++) {
                tokens.push(await ILevel4Instance.tokens(i))
            }
            IDAI = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[0])
            IGHST = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[1])
            expect(parseInt(formatEther(await IDAI.balanceOf(player1.address)))).to.equal(10)
            expect(parseInt(formatEther(await IGHST.balanceOf(player1.address)))).to.equal(10)
        })
        it('an AMM with one pool active', async () => {
            FACTORY = await ethers.getContractFactory("UniswapV2Factory", await ILevel4Instance.factory())
            expect(parseInt(formatEther(await FACTORY.allPairsLength()))).to.equal(1)
        })
    })
})
  