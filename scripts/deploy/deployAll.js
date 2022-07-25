/* global ethers */
/* eslint prefer-const: "off" */

const hardhat = require("hardhat")
const { deployDiamond } = require("./deployDiamond.js")
// AMM
const { deployRouterFacet } = require("./facets/deployRouterFacet.js")
const { deployFactoryFacet } = require("./facets/deployFactoryFacet.js")
const { deployTokenFacet } = require('./facets/deployTokenFacet.js')
//Reward
const { deployRewardFacet } = require("./facets/deployRewardFacet.js")
const { deploySvgFacet } = require("./facets/deploySvgFacet.js")
const { deploySvgLoupeFacet } = require("./facets/deploySvgLoupeFacet.js")
// Level
const { deployLevelLoupeFacet } = require("./facets/deployLevelLoupeFacet.js")
const { deployLevel0Facet } = require("./facets/deployLevel0Facet.js")
const { deployLevel1Facet } = require("./facets/deployLevel1Facet.js")
const { deployLevel2Facet } = require("./facets/deployLevel2Facet.js")
const { deployLevel3Facet } = require("./facets/deployLevel3Facet.js")
const { deployLevel4Facet } = require("./facets/deployLevel4Facet.js")
const { deployLevel5Facet } = require("./facets/deployLevel5Facet.js")
const { deployLevel6Facet } = require("./facets/deployLevel6Facet.js")
const { deployLevel7Facet } = require("./facets/deployLevel7Facet.js")
const { deployLevel8Facet } = require("./facets/deployLevel8Facet.js")
const { deployLevel9Facet } = require("./facets/deployLevel9Facet.js")
const { deployLevel10Facet } = require("./facets/deployLevel10Facet.js")
const { deployLevel11Facet } = require("./facets/deployLevel11Facet.js")
const { deployLevel12Facet } = require("./facets/deployLevel12Facet.js")
const { deployLevel13Facet } = require("./facets/deployLevel13Facet.js")

async function deployAll () {
    const deploys = [
        deployDiamond,
        deployRouterFacet,
        deployFactoryFacet,
        deployTokenFacet,
        deployRewardFacet,
        deploySvgFacet,
        deploySvgLoupeFacet,
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
