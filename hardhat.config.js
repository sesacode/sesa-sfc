require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-truffle5');
require('@nomiclabs/hardhat-web3');
require('@openzeppelin/test-helpers');
require('hardhat-contract-sizer');
require('@nomiclabs/hardhat-etherscan');
require('dotenv').config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const API_KEY = process.env.API_KEY;

module.exports = {
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true
    },
    localhost: {
      url: 'http://127.0.0.1:8545'
    },
    mainnet: {
      url: 'https://rpc-mainnet.sesa.network',
      chainId: 39
    },
    testnet: {
      url: 'https://rpc-nebulas-testnet.sesa.network',
      chainId: 2484,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: {
      sesaTestnet: API_KEY
    }
  },
  contractSizer: {
    runOnCompile: true
  },
  mocha: {},
  abiExporter: {
    path: './build/contracts',
    clear: true,
    flat: true,
    spacing: 2
  },
  solidity: {
    version: '0.5.17',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  gasReporter: {
    currency: 'USD',
    enabled: false,
    gasPrice: 50
  }
};
