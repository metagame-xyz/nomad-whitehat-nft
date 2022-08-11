// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "../src/Logbook.sol";

contract DeployLogbook is Script {
    function run() external {
        vm.startBroadcast();

         logbook logbookInstance = new logbook(
            "Logbook", // name
            "LGBK", // symbol
            "https://logbook.themetagame.xyz/api/metadata/", // metadata folder uri
            1, // mints per address
            "https://logbook.themetagame.xyz/api/contract-metadata", // opensea contract metadata url
            false, // is mint active?
            0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f // valid signer
        );

        vm.stopBroadcast();
    }
}
