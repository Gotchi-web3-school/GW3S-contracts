
/* global ethers task */
require('@nomiclabs/hardhat-waffle')
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-solhint");

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
const INFURA_PROJECT_ID = process.env.INFURA_PROJECT_ID;
const DEPLOYER_PRIVATE_KEY = process.env.DEPLOYER_PRIVATE_KEY;
const DEPLOYER2_PRIVATE_KEY = process.env.DEPLOYER2_PRIVATE_KEY;
const DEPLOYER3_PRIVATE_KEY = process.env.DEPLOYER3_PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */


module.exports = {
  settings: {
    optimizer: {
      enabled: true,
      viaIR: true,
      runs: 200
    }
  },
  solidity: {
    compilers: [
      {version: "0.8.15"},
      {version: "0.8.14"},
      {version: "0.8.1"},
      {version: "0.8.0"},
      {version: "0.6.12"},
      {version: "0.5.16"},
    ],
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
     // url: `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_PROJECT_ID}`,
      url: `https://polygon-mumbai.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
      gasPrice: 40000000000, // 40 gwei
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY
  },
}
