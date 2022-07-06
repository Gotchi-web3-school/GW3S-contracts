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
  const { deployLevel7 } = require('../scripts/deploy/deployLevel7Facet.js')
  const { expect } = require('chai')
  
describe("Level 7", () => {
    let diamondAddress, level7Address, factoryFacetsAddress, instanceAddress, routerAddress
    let diamondCutFacet, diamondLoupeFacet, ownershipFacet, level7Facet, levelLoupeFacet
    let player1, player2, player7
    let tx, receipt
    let IGHST, IDAI, IERC20, IROUTER, IFACTORY, ILevel7Instance
    let player;
    let levelId;
    let tokens = []
    let Loupe
    
    before(async function () {
        [player1, player2, player7] = await ethers.getSigners()
        diamondAddress = await deployDiamond()
        routerAddress = await deployRouter()
        levelLoupeAddress = await deployLevelLoupeFacet(diamondAddress)
        factoryFacetsAddress = await deployFactoryFacets(routerAddress, diamondAddress)
        level7Address = await deployLevel7(diamondAddress)
        
        diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
        diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
        ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
        levelLoupeFacet = await ethers.getContractAt('LevelLoupeFacet', diamondAddress)
        level7Facet = await ethers.getContractAt('Level7Facet', diamondAddress)
        IERC20 = await ethers.getContractFactory("@openzeppelin/contracts/token/ERC20/ERC20.sol:ERC20")
    })
    
    describe("init", () => {
        it('should return the address of level7Facet', async () => {
            const address = await levelLoupeFacet.getAddress(7)
            expect(address).to.equal(level7Address)
        })
        it('should return false on "Completed & reward"', async () => {
            const isCompleted = await levelLoupeFacet.hasCompletedLevel(player1.address, 7)
            const isClaimedLevel = await levelLoupeFacet.hasClaimedLevel(player1.address, 7)
            
            expect(isCompleted).to.equal(false, "isCompleted failed")
            expect(isClaimedLevel).to.equal(false, "isClaimedLevel failed")
        })
        it('should instanciate a new level 7', async () => {
            await level7Facet.initLevel7()
        })
    })

    describe("play", () => {
        before(async function () {
            tx = await level7Facet.initLevel7()
            receipt = await tx.wait()
            receipt.events.forEach(element =>{ 
                if (element.event === "DeployedInstance") {
                    Level7Instance = element.args.instance
                    player = element.args.player
                    levelId = element.args.level
                }
            })
        })

        it('should have a balance of 100 for GHST & DAI', async () => {
            console.log(player1)
            Ilevel7Instance = await ethers.getContractAt('ILevel7Instance', await levelLoupeFacet.getLevelInstanceByAddress(player1.address, 7))
            const token0 = IERC20.attach(await ILevel7Instance.tokens(0))
            const token1 = IERC20.attach(await ILevel7Instance.tokens(1))
            expect(token0.balanceOf(player)).to.equal(parseEther(100))
            expect(token1.balanceOf(player)).to.equal(parseEther(100))
        })
        it('should return false on "Completed & reward"', async () => {
            const isCompleted = await levelLoupeFacet.hasCompletedLevel(player1.address, 7)
            const isClaimedLevel = await levelLoupeFacet.hasClaimedLevel(player1.address, 7)
            
            expect(isCompleted).to.equal(false, "isCompleted failed")
            expect(isClaimedLevel).to.equal(false, "isClaimedLevel failed")
        })
        it('should instanciate a new level 7', async () => {
            await level7Facet.initLevel7()
        })
    })
})
  