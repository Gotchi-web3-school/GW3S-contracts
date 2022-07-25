/* global describe it before ethers */

  const { ethers } = require('hardhat')
  const {formatEther, parseEther} = ethers.utils
  
  const { deployAll } = require('../scripts/deploy/deployAll.js')
  const { level3 } = require("../scripts/play/level3.js");

  const { expect } = require('chai')
  
describe("Level 3", () => {
    let player1, player2, player3
    
    before(async function () {
        [player1, player2, player3] = await ethers.getSigners()
        await deployAll()
        await level3()
    })
  
})
  