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
  const { deployLevel3 } = require('../scripts/deploy/deployLevel3Facet.js')
  const { expect } = require('chai')
  
describe("Level 3", () => {
    let diamondAddress, level3Address, factoryFacetsAddress, instanceAddress, routerAddress
    let diamondCutFacet, diamondLoupeFacet, ownershipFacet, level3Facet, levelLoupeFacet
    let player1, player2, player3
    let tx, receipt
    let IGHST, IDAI, IERC20, IROUTER, IFACTORY, ILevel3Instance
    let player;
    let levelId;
    let tokens = []
    let Loupe
    
    before(async function () {
        
        [player1, player2, player3] = await ethers.getSigners()
        diamondAddress = await deployDiamond()
        routerAddress = await deployRouter()
        levelLoupeAddress = await deployLevelLoupeFacet(diamondAddress)
        factoryFacetsAddress = await deployFactoryFacets(routerAddress, diamondAddress)
        level3Address = await deployLevel3(diamondAddress)
        
        diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
        diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
        ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
        levelLoupeFacet = await ethers.getContractAt('LevelLoupeFacet', diamondAddress)
        level3Facet = await ethers.getContractAt('Level3Facet', diamondAddress)
    })
    
    describe("init", () => {
        it('should return the address of level3Facet', async () => {
            const address = await levelLoupeFacet.getAddress(3)
            expect(address).to.equal(level3Address)
        })
        it('should return false on "Completed & reward"', async () => {
            const isCompleted = await levelLoupeFacet.hasCompletedLevel(player1.address, 3)
            const isClaimedLevel = await levelLoupeFacet.hasClaimedLevel(player1.address, 3)
            
            expect(isCompleted).to.equal(false, "isCompleted failed")
            expect(isClaimedLevel).to.equal(false, "isClaimedLevel failed")
        })
        it('should instanciate a new level 3', async () => {
        
            await level3Facet.initLevel()
           // await levelLoupeFacet.getLevelInstanceAddress(player1.address, 3)
        })
    })
    
    describe("play", () => {
        
        before(async function () {
            tx = await level3Facet.initLevel()
            receipt = await tx.wait()
            deployedInstance = receipt.events.forEach(element =>{ 
                if (element.event === "DeployedInstance") {
                    instanceAddress = element.args.instance
                    player = element.args.player
                    levelId = element.args.level
                }
            })
            ILevel3Instance = await ethers.getContractAt("ILevel3Instance", instanceAddress)
            for(let i = 0; i < 2; i++) {
                tokens.push(await ILevel3Instance.tokens(i))
            }
        })
  
        it('should return the address of the player', async () => {
            expect(await ILevel3Instance.player()).to.equal(player)
        })
        it('should return the id of the level (3)', async () => {
            expect(await levelId).to.equal(3)
        })
        it('should return the tokens SYMBOL', async () => {
            let tokens = ["DAI", "GHST"]
            for(let i = 0; i < 2; i++) {
                expect(await ILevel3Instance.TOKENS_SYMBOL(i)).to.equal(tokens[i])
            }
        })
        it('should start game with player having 10 DAI & 0 GHST', async () => {
            for(let i = 0; i < 2; i++) {
                tokens.push(await ILevel3Instance.tokens(i))
            }
            IDAI = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[0])
            IGHST = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[1])
            expect(parseInt(formatEther(await IDAI.balanceOf(player1.address)))).to.equal(10)
            expect(parseInt(formatEther(await IGHST.balanceOf(player1.address)))).to.equal(10)
        })
        it('an AMM with one pool active', async () => {
            FACTORY = await ethers.getContractFactory("UniswapV2Factory", await ILevel3Instance.factory())
            expect(parseInt(formatEther(await FACTORY.allPairsLength()))).to.equal(1)
        })
        it('should approve tokens to instance and ship to them', async () => {
            for(let i = 0; i < 4; i++) {
                IERC20 = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[i])
                await IERC20.approve(instanceAddress, "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
            }
            
            await ILevel2Instance.shipTokens()

            // balance of player = 0
            for(let i = 0; i < 4; i++) {
                IERC20 = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[i])
                expect(parseInt(formatEther(await IERC20.balanceOf(player1.address)))).to.equal(0)
            }
            // balance of instance = 10
            for(let i = 0; i < 4; i++) {
                IERC20 = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[i])
                expect(parseInt(formatEther(await IERC20.balanceOf(instanceAddress)))).to.equal(10)
            }
            expect(await ILevel2Instance.shipped()).to.equal(true)
        })
    })
    /*
    describe("Complete and claim reward", () => {
        let instanceAddress;
        let ILevel2Instance;
        let player;
        let levelId;
        let tokens = []
        let IERC20;
        
        // init level
        before(async function () {
            tx = await level2Facet.initLevel()
            receipt = await tx.wait()
            deployedInstance = receipt.events.forEach(element =>{ 
                if (element.event === "DeployedInstance") {
                    instanceAddress = element.args.instance
                    player = element.args.player
                    levelId = element.args.level
                }
            })
            ILevel2Instance = await ethers.getContractAt("ILevel2Instance", instanceAddress)
            for(let i = 0; i < 4; i++) {
                tokens.push(await ILevel2Instance.tokens(i))
            }

        })
        
        it('should revert when trying Complete level', async () => {
            await expect(level2Facet.complete_l2()).to.be.revertedWith("level not completed yet")
        })
        it('should revert when trying claim reward', async () => {
            await expect(level2Facet.claim_l2()).to.be.revertedWith("Claim_l2: You need to complete the level first")
        })
        
        it('should Complete level', async () => {
            // finish level
            for(let i = 0; i < 4; i++) {
                IERC20 = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[i])
                await IERC20.approve(instanceAddress, "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
            }
            await ILevel2Instance.shipTokens()
                
            tx = await level2Facet.complete_l2()
            await tx.wait()

            expect(await levelLoupeFacet.hasCompletedLevel(player1.address, 2)).to.equal(true)
        })
        it('should be able to claim reward', async () => {
            tx = await level2Facet.claim_l2()
            await tx.wait()

            expect(await levelLoupeFacet.hasClaimedLevel(player1.address, 2)).to.equal(true)
        })
    })

    describe("Start again", () => {
        let instanceAddress;
        let newinstanceAddress;
        let ILevel2Instance;
        let player;
        let levelId;
        let tokens = []
        let IERC20;
        it('should have completed the level', async () => {
            expect(await levelLoupeFacet.hasCompletedLevel(player1.address, 2)).to.equal(true)
        })
        it('should have claimed reward', async () => {
            expect(await levelLoupeFacet.hasClaimedLevel(player1.address, 2)).to.equal(true)
        })
        it('init the instance again and change completed state to false', async () => {
            tx = await level2Facet.initLevel()
            receipt = await tx.wait()
            deployedInstance = receipt.events.forEach(element =>{ 
                if (element.event === "DeployedInstance") {
                    newinstanceAddress = element.args.instance
                    player = element.args.player
                    levelId = element.args.level
                }
            })
            console.log(instanceAddress)
            expect(newinstanceAddress).not.equal(instanceAddress)
            expect(await levelLoupeFacet.hasCompletedLevel(player1.address, 2)).to.equal(false)
        })
    })
    */
  
})
  