# Logbook contract

## How to deploy

1. Install the forge CLI (https://book.getfoundry.sh/getting-started/installation)

2. Run `forge build`

3. Run `forge create --rpc-url https://eth-rinkeby.alchemyapi.io/v2/<ALCHEMY_PROJECT_ID> --constructor-args <CONTRACT_NAME> <CONTRACT_SYMBOL> <METADATA_FOLDER_URI> <FREE_MINTS> <MINTS_PER_ADDRESS> <OPENSEA_CONTRACT_METADATA_URL> <IS_MINT_ACTIVE> --private-key <DEPLOYER_PRIVATE_KEY> src/Logbook.sol:logbook`

NOTE: The `IS_MINT_ACTIVE` field should be `true` or `false`. The constructor args that are strings do NOT need to be wrapped in quotation marks.
