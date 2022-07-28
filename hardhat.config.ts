/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 import * as dotenv from 'dotenv';
 // import 'hardhat-contract-sizer';
 import '@nomiclabs/hardhat-etherscan';
 import '@nomiclabs/hardhat-waffle';
 import '@nomiclabs/hardhat-ethers';
 import 'hardhat-gas-reporter';
 
 dotenv.config();
 
 const {
     RINKEBY_ALCHEMY_URL,
     DEPLOYER_PRIVATE_KEY,
     MAINNET_ALCHEMY_URL,
     ETHERSCAN_API_KEY,
 } = process.env;
 
 const gas = 100;
 const gwei = 10 ** 9;
 
 export default {
     solidity: {
         version: '0.8.10',
         settings: {
             optimizer: {
                 enabled: true,
                 runs: 1,
             },
         },
     },
     // defaultNetwork: "rinkeby",
     networks: {
         hardhat: {
             chainId: 1337,
         },
         rinkeby: {
             url: RINKEBY_ALCHEMY_URL,
             accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
             // gasPrice: gas * gwei,
         },
         mainnet: {
             url: MAINNET_ALCHEMY_URL,
             accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
             // gasPrice: 'auto',
             // gasMultiplier: 1.05,
         },
     },
     //   contractSizer: {
     //     alphasort: true,
     //     runOnCompile:true,
     //     disambiguatePaths: false,
     //  },
     etherscan: {
         apiKey: ETHERSCAN_API_KEY,
     },
 };