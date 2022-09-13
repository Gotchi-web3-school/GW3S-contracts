/* global ethers */
/* eslint prefer-const: "off" */

const { ethers } = require("hardhat");
const hardhat = require("hardhat")

async function SummitArtist1 () {
  let tx, receipt, common, secret, hacker;

  //svg polygon
  const svgs = {
    front: "0x3bC871313BD161aA9834f5A43d625c87cB381244",
    back: "0x203DbF25DB4d0857654d41436F68897aD8560Daf",
    left: "0xa4c9a6Fdf153775229a7aBe5756E1e8519C0c912",
    right: "0xbA842863635D1c0979d1DE451ED5eB40241233CC"
  }

  console.log("Deploying GMI artist's summit #1...")
  const GMIartistSummit = await ethers.getContractFactory("GW3SArtistSummit")
  const gmi1 = await GMIartistSummit.deploy("GMI artists summit", "GMIas")
  await gmi1.deployed()
  console.log("deployed !")
  console.log("address: ", gmi1.address)

  console.log("Mint token 1 to 0xe560f310EE0B94D435e6282829363c3Ec77b7cA6...")
  tx = await gmi1.safeMint(
    "0xe560f310EE0B94D435e6282829363c3Ec77b7cA6",
    svgs,
    "GMI artist's summit",
    "Frens forever",
    "https://gateway.pinata.cloud/ipfs/QmZZPP5CA8ce3bquidq5HhjVDft6nbnyMQtpDrpuLEwcNg"
  )
  await tx.wait()
  console.log("Minted !")
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
