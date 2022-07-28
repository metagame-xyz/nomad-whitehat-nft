const contractName = 'logbook'; //links to the file name in contracts/<filename.sol>

const env = process.env.HARDHAT_NETWORK === 'mainnet' ? '' : '-dev';

const nftName = 'Logbook';
const symbol = 'LGBK';
const metadataFolderURL = `https://logbook${env}.themetagame.xyz/api/metadata`;
const freeMints = 0;
const mintsPerAddress = 10;
const openseaContractMetadataURI = `https://logbook${env}.themetagame.xyz/api/contract-metadata`;
const mintActive = !(process.env.HARDHAT_NETWORK === 'mainnet');
const validSigner = process.env.VALID_SIGNER

const contractArgs = [
    nftName,
    symbol,
    metadataFolderURL,
    freeMints,
    mintsPerAddress,
    openseaContractMetadataURI,
    mintActive,
    validSigner,
];
export { contractName, contractArgs };