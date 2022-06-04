const HDWalletProvider = require('@truffle/hdwallet-provider');
const { env } = require('process');
require('dotenv').config()

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    ropsten: {
      provider: () => new HDWalletProvider(env.MNEMONIC, `https://ropsten.infura.io/v3/${env.INFURA_PROJECT_ID}`),
      network_id: 3,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  },
  compilers: {
    solc: {
      version: "0.8.13",
    }
  },
};
