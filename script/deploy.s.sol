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
            "https://?.themetagame.xyz/api/metadata/", // metadata folder uri
            1, // mints per address
            "https://?.themetagame.xyz/api/contract-metadata", // opensea contract metadata url
            false, // is mint active?
            0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f // valid signer
        );

        vm.stopBroadcast();
    }
}
