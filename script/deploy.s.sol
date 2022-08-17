// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Script.sol";
import "../src/Whitehat.sol";

contract DeployWhitehat is Script {
    function run() external {
        vm.startBroadcast();

         whitehat whitehatInstance = new whitehat(
            "Nomad Whitehat", // name
            "WHTHT", // symbol
            "https://nomad-whitehat-dev.themetagame.xyz/api/v1/metadata/", // metadata folder uri
            100, // mints per address
            "https://nomad-whitehat-dev.themetagame.xyz/api/v1/contract-metadata", // opensea contract metadata url
            true, // is mint active?
            0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f // valid signer
        );

        vm.stopBroadcast();
    }
}
