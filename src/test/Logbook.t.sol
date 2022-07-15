// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "../Logbook.sol";
import "forge-std/console.sol";

contract logbookTest is Test {
    address constant signer = 0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f;
    address constant minter = 0x9bEF1f52763852A339471f298c6780e158E43A68;

    // hardcoded from metabot API
    bytes32 constant r =
        0x65f93e511210659aa1eaba930c11cfb15dc51ffb6fea27c94f762b99ca62c703;
    bytes32 constant s =
        0x45ec41a014971ce41163f7cbd78c53a8f6f25222e954c8e5ee7f67d2f81603f6;
    uint8 constant v = 28;
    logbook logbookContract;

    constructor() {
        vm.prank(0x44C489197133D7076Cd9ecB33682D6Efd271c6F7);
        logbookContract = new logbook(
            "Logbook",
            "LGBK",
            "NOT_IMPLEMENTED",
            0,
            1,
            "NOT_IMPLEMENTED",
            false,
            0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f
        );
    }

    function setUp() public {
        vm.prank(0x44C489197133D7076Cd9ecB33682D6Efd271c6F7);
        logbookContract.setMintActive(true);
    }

    function testFailSetActiveByNonOwner() public {
        vm.prank(0x9bEF1f52763852A339471f298c6780e158E43A68);
        logbookContract.setMintActive(true);
    }

    function testMintNotFree() public {
        vm.prank(0x44C489197133D7076Cd9ecB33682D6Efd271c6F7);
        assertFalse(logbookContract.isMintFree());
    }

    function testMintWithSignature() public {
        vm.deal(0x9bEF1f52763852A339471f298c6780e158E43A68, 100000000000000000);
        vm.prank(0x9bEF1f52763852A339471f298c6780e158E43A68);

        uint256 newTokenId = logbookContract.mintWithSignature{
            value: 10000000000000000
        }(minter, v, r, s);
        assertEq(newTokenId, 1);
    }

    function testCannotMintTwice() public {
        vm.deal(0x9bEF1f52763852A339471f298c6780e158E43A68, 100000000000000000);
        vm.prank(0x9bEF1f52763852A339471f298c6780e158E43A68);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
        vm.prank(0x9bEF1f52763852A339471f298c6780e158E43A68);
        vm.expectRevert(bytes("only 1 mint per wallet address"));
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testMustMintForYourself() public {
        vm.deal(0x44C489197133D7076Cd9ecB33682D6Efd271c6F7, 100000000000000000);
        vm.expectRevert(bytes("you have to mint for yourself"));
        vm.prank(0x44C489197133D7076Cd9ecB33682D6Efd271c6F7);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testCannotUnderpay() public {
        vm.deal(0x9bEF1f52763852A339471f298c6780e158E43A68, 100000000000000000);
        vm.expectRevert(bytes("This mint costs 0.01 eth"));
        vm.prank(0x9bEF1f52763852A339471f298c6780e158E43A68);
        logbookContract.mintWithSignature{value: 9000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testCannotFakeSignature() public {
        address newSigner = 0x44C489197133D7076Cd9ecB33682D6Efd271c6F7;
        vm.prank(0x44C489197133D7076Cd9ecB33682D6Efd271c6F7);
        logbookContract.setValidSigner(newSigner);

        vm.deal(0x9bEF1f52763852A339471f298c6780e158E43A68, 100000000000000000);
        vm.expectRevert(bytes("Invalid signer"));
        vm.prank(0x9bEF1f52763852A339471f298c6780e158E43A68);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
    }
}
