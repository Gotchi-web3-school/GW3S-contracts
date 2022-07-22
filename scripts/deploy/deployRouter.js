/* global ethers */
/* eslint prefer-const: "off" */

const { deployed } = require("../libraries/deployed.js")
const hardhat = require("hardhat")
const FILE_PATH = './helpers/facetsContracts.json';
const WETH_MUMBAI_ADDRESS = "0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa"

async function deployRouter () {
  const cut = [];

  console.log("Deploying router...")
  const Router = await ethers.getContractFactory("Router")
  const router = await Router.deploy(WETH_MUMBAI_ADDRESS)
  await router.deployed()
  console.log("Deployed !")

  deployed("Router", hardhat.network.name, router.address)

  cut.push({
    facetAddress: facet.address,
    action: FacetCutAction.Add,
    functionSelectors: getSelectors(facet)
  })

  return router.address
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
    deployRouter()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployRouter = deployRouter
