
/* global ethers task */
require('@nomiclabs/hardhat-waffle')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
})

require('dotenv').config();
const ALCHEMY_PROJECT_ID = process.env.ALCHEMY_PROJECT_ID;
const DEPLOYER_PRIVATE_KEY = process.env.DEPLOYER_PRIVATE_KEY;

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.6',
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  networks: {
    hardhat: {
      // workaround from https://github.com/sc-forks/solidity-coverage/issues/652#issuecomment-896330136 .
      // Remove when that issue is closed.
      initialBaseFeePerGas: 0,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${ALCHEMY_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${ALCHEMY_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${ALCHEMY_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${ALCHEMY_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
  },
}
