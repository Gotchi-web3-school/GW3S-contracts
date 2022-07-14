/* global ethers */
/* eslint prefer-const: "off" */

const { getSelectors, FacetCutAction } = require('../libraries/diamond.js')
const hardhat = require("hardhat")
const { deployRouter } = require("./deployRouter.js")
const { deployDiamond } = require("./deployDiamond.js")
const { deployFactoryFacet } = require("./deployFactoryFacet.js")
const { deployTokenFacet } = require('./deployTokenFacet.js')
const { deployLevelLoupeFacet } = require("./deployLevelLoupeFacet.js")
const { deployLevel0Facet } = require("./deployLevel0Facet.js")
const { deployLevel1Facet } = require("./deployLevel1Facet.js")
const { deployLevel2Facet } = require("./deployLevel2Facet.js")
const { deployLevel3Facet } = require("./deployLevel3Facet.js")
const { deployLevel4Facet } = require("./deployLevel4Facet.js")
const { deployLevel5Facet } = require("./deployLevel5Facet.js")
const { deployLevel6Facet } = require("./deployLevel6Facet.js")
const { deployLevel7Facet } = require("./deployLevel7Facet.js")
const { deployLevel8Facet } = require("./deployLevel8Facet.js")
const { deployLevel9Facet } = require("./deployLevel9Facet.js")
const { deployLevel10Facet } = require("./deployLevel10Facet.js")
const { deployLevel11Facet } = require("./deployLevel11Facet.js")
const { deployLevel12Facet } = require("./deployLevel12Facet.js")
const { deployLevel13Facet } = require("./deployLevel13Facet.js")

async function deployAll () {
    const deploys = [
        deployRouter,
        deployDiamond,
        deployFactoryFacet,
        deployTokenFacet,
        deployLevelLoupeFacet,
        deployLevel0Facet,
        deployLevel1Facet,
        deployLevel2Facet,
        deployLevel3Facet,
        deployLevel4Facet,
        deployLevel5Facet,
        deployLevel6Facet,
        deployLevel7Facet,
        deployLevel8Facet,
        deployLevel9Facet,
        deployLevel10Facet,
        deployLevel11Facet,
        deployLevel12Facet,
        deployLevel13Facet,
    ]
    for (facet of deploys){
        try {
            await facet();
        } catch (error) {
          console.log(error.message)
        }
    }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  deployAll()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployAll = deployAll
