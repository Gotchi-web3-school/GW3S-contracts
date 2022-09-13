/* global ethers */
/* eslint prefer-const: "off" */

const { ethers } = require("hardhat");
const hardhat = require("hardhat")

async function SummitArtist1 () {
  let tx, receipt, common, secret, hacker;

  const Land = await ethers.getContractAt("IERC721", "0x726F201A9aB38cD56D60ee392165F1434C4F193D")
  const Chest = await ethers.getContractAt('GMIChest', "0xc53fb4A783a6fddD1B4a28BF4FC97D915Ba9fA73")

  console.log("Approving Land to chest")
  tx = await Land.approve(Chest.address, 100)
  await tx.wait()
  console.log("Land approved to chest !")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  SummitArtist1()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.SummitArtist1 = SummitArtist1
