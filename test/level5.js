/* global describe it before ethers 

const {
    getSelectors,
    FacetCutAction,
    removeSelectors,
    findAddressPositionInFacets
  } = require('../scripts/libraries/diamond.js')
  const { ethers } = require('hardhat')
  const {formatEther, parseEther} = ethers.utils
  
  const { deployDiamond } = require('../scripts/deploy/deployDiamond.js')
  const { deployLevel5 } = require('../scripts/deploy/deployLevel5Facet.js')
  const { deployLevelLoupeFacet } = require('../scripts/deploy/deployLevelLoupeFacet.js')
  const { expect } = require('chai')
  
describe("Level 2", () => {
    let diamondAddress
    let level5Address
    let levelLoupeAddress
    let diamondCutFacet
    let diamondLoupeFacet
    let ownershipFacet
    let level5Facet
    let levelLoupeFacet
    let tx
    let receipt
    let result
    const addresses = []
    let player1, player2, player3
    
    before(async function () {
        [player1, player2, player3] = await ethers.getSigners()
        diamondAddress = await deployDiamond()
        levelLoupeAddress = await deployLevelLoupeFacet(diamondAddress)
        level5Address = await deployLevel5(diamondAddress)
        
        diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
        diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
        ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
        levelLoupeFacet = await ethers.getContractAt('LevelLoupeFacet', diamondAddress)
        level5Facet = await ethers.getContractAt('Level5Facet', diamondAddress)
    })
    
    describe("init", () => {
        
        it('should have four facets -- call to facetAddresses function', async () => {
            for (const address of await diamondLoupeFacet.facetAddresses()) {
                addresses.push(address)
            }
            expect(addresses.length).to.equal(5)
        })
        it('should return the address of level5Facet', async () => {
            const address = await levelLoupeFacet.getAddress(2)
            
            expect(address).to.equal(level5Address)
        })
        it('should return false on "Completed & reward"', async () => {
            const isCompleted = await levelLoupeFacet.hasCompletedLevel(player1.address, 2)
            const isClaimedLevel = await levelLoupeFacet.hasClaimedLevel(player1.address, 2)
            
            expect(isCompleted).to.equal(false, "isCompleted failed")
            expect(isClaimedLevel).to.equal(false, "isClaimedLevel failed")
        })
        it('should instanciate a new level 2', async () => {
            await expect(level5Facet.initLevel())
            .to.emit(level5Facet, "DeployedInstance")
            .withArgs(2, player1.address, await levelLoupeFacet.getLevelInstanceAddress(player1.address, 2));
        })
    })
    
    describe("play", () => {
        let instanceAddress;
        let ILevel5Instance;
        let player;
        let levelId;
        let tokens = []
        let IERC20;
        
        before(async function () {
            tx = await level5Facet.initLevel()
            receipt = await tx.wait()
            deployedInstance = receipt.events.forEach(element =>{ 
                if (element.event === "DeployedInstance") {
                    instanceAddress = element.args.instance
                    player = element.args.player
                    levelId = element.args.level
                }
            })
            ILevel5Instance = await ethers.getContractAt("ILevel5Instance", instanceAddress)
            for(let i = 0; i < 4; i++) {
                tokens.push(await ILevel5Instance.tokens(i))
            }
        })
  
        it('should return the address of the player', async () => {
            expect(await ILevel5Instance.player()).to.equal(player)
        })
        it('should return the id of the level (2)', async () => {
            expect(await levelId).to.equal(2)
        })
        it('should return the tokens SYMBOL', async () => {
            let tokens = ["KEK", "ALPHA", "FOMO", "FUD"]
            for(let i = 0; i < 4; i++) {
                expect(await ILevel5Instance.TOKENS_SYMBOL(i)).to.equal(tokens[i])
            }
        })
        it('should start game with shipped at false', async () => {
            expect(await ILevel5Instance.shipped()).to.equal(false)
        })
        it('should start with 10 tokens of each', async () => {
            for(let i = 0; i < 4; i++) {
                IERC20 = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[i])
                expect(parseInt(formatEther(await IERC20.balanceOf(player1.address)))).to.equal(10)
            }
        })
        it('should approve tokens to instance and ship to them', async () => {
            for(let i = 0; i < 4; i++) {
                IERC20 = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[i])
                await IERC20.approve(instanceAddress, "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
            }
            
            await ILevel5Instance.shipTokens()

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
            expect(await ILevel5Instance.shipped()).to.equal(true)
        })
    })

    describe("Complete and claim reward", () => {
        let instanceAddress;
        let ILevel5Instance;
        let player;
        let levelId;
        let tokens = []
        let IERC20;
        
        // init level
        before(async function () {
            tx = await level5Facet.initLevel()
            receipt = await tx.wait()
            deployedInstance = receipt.events.forEach(element =>{ 
                if (element.event === "DeployedInstance") {
                    instanceAddress = element.args.instance
                    player = element.args.player
                    levelId = element.args.level
                }
            })
            ILevel5Instance = await ethers.getContractAt("ILevel5Instance", instanceAddress)
            for(let i = 0; i < 4; i++) {
                tokens.push(await ILevel5Instance.tokens(i))
            }

        })
        
        it('should revert when trying Complete level', async () => {
            await expect(level5Facet.complete_l5()).to.be.revertedWith("level not completed yet")
        })
        it('should revert when trying claim reward', async () => {
            await expect(level5Facet.claim_l5()).to.be.revertedWith("Claim_l5: You need to complete the level first")
        })
        
        it('should Complete level', async () => {
            // finish level
            for(let i = 0; i < 4; i++) {
                IERC20 = await ethers.getContractAt("@openzeppelin/contracts/token/ERC20/IERC20.sol:IERC20", tokens[i])
                await IERC20.approve(instanceAddress, "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
            }
            await ILevel5Instance.shipTokens()
                
            tx = await level5Facet.complete_l5()
            await tx.wait()

            expect(await levelLoupeFacet.hasCompletedLevel(player1.address, 2)).to.equal(true)
        })
        it('should be able to claim reward', async () => {
            tx = await level5Facet.claim_l5()
            await tx.wait()

            expect(await levelLoupeFacet.hasClaimedLevel(player1.address, 2)).to.equal(true)
        })
    })

    describe("Start again", () => {
        let instanceAddress;
        let newinstanceAddress;
        let ILevel5Instance;
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
            tx = await level5Facet.initLevel()
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
  
})
  */