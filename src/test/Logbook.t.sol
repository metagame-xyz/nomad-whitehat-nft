// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../Logbook.sol";
import "forge-std/console.sol";

contract logbookTest is Test {
    address constant owner = 0x44C489197133D7076Cd9ecB33682D6Efd271c6F7;
    address constant signer = 0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f;
    address constant minter = 0x9bEF1f52763852A339471f298c6780e158E43A68;
    address constant minter2 = 0xFFff0BE2f91F2B4a5c22aEBbd928A9565EE92ccb;

    // hardcoded from metabot API
    bytes32 constant r =
        0x65f93e511210659aa1eaba930c11cfb15dc51ffb6fea27c94f762b99ca62c703;
    bytes32 constant s =
        0x45ec41a014971ce41163f7cbd78c53a8f6f25222e954c8e5ee7f67d2f81603f6;
    uint8 constant v = 28;

    bytes32 constant r2 =
        0xe00f2c4019c2747168fea87d6861efc9b214aa8bdccee0107d8e4d8e27f0909c;
    bytes32 constant s2 =
        0x3e7805db1391c3bd5bc11babf58bceb0b386e5efb02a9f130ae20b4ade9f9476;
    uint8 constant v2 = 28;

    logbook logbookContract;

    constructor() {
        vm.prank(owner);
        logbookContract = new logbook(
            "Logbook",
            "LGBK",
            "NOT_IMPLEMENTED",
            0,
            1,
            "NOT_IMPLEMENTED",
            false,
            signer
        );
    }

    function setUp() public {
        vm.prank(owner);
        logbookContract.setMintActive(true);
    }

    function testFailSetActiveByNonOwner() public {
        vm.prank(minter);
        logbookContract.setMintActive(true);
    }

    function testMintNotFree() public {
        vm.prank(owner);
        assertFalse(logbookContract.isMintFree());
    }

    function testMintWithSignature() public {
        vm.deal(minter, 100000000000000000);
        vm.prank(minter);

        uint256 newTokenId = logbookContract.mintWithSignature{
            value: 10000000000000000
        }(minter, v, r, s);
        assertEq(newTokenId, 1);
    }

    function testCannotMintTwice() public {
        vm.deal(minter, 100000000000000000);
        vm.prank(minter);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
        vm.prank(minter);
        vm.expectRevert(bytes("only 1 mint per wallet address"));
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testMustMintForYourself() public {
        vm.deal(owner, 100000000000000000);
        vm.expectRevert(bytes("you have to mint for yourself"));
        vm.prank(owner);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testCannotUnderpay() public {
        vm.deal(minter, 100000000000000000);
        vm.expectRevert(bytes("This mint costs 0.01 eth"));
        vm.prank(minter);
        logbookContract.mintWithSignature{value: 9000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testCannotFakeSignature() public {
        address newSigner = owner;
        vm.prank(owner);
        logbookContract.setValidSigner(newSigner);

        vm.deal(minter, 100000000000000000);
        vm.expectRevert(bytes("Invalid signer"));
        vm.prank(minter);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );
    }

    function testContractBalance() public {
        vm.deal(minter, 100000000000000000);
        vm.prank(minter);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );

        vm.deal(minter2, 100000000000000000);
        vm.prank(minter2);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter2,
            v2,
            r2,
            s2
        );
        assertEq(logbookContract.getBalance(), 20000000000000000);
    }

    function testMultipleMints() public {
        vm.deal(minter, 100000000000000000);
        vm.prank(minter);
        uint256 newTokenId = logbookContract.mintWithSignature{
            value: 10000000000000000
        }(minter, v, r, s);
        assertEq(newTokenId, 1);

        vm.deal(minter2, 100000000000000000);
        vm.prank(minter2);
        uint256 newTokenId2 = logbookContract.mintWithSignature{
            value: 10000000000000000
        }(minter2, v2, r2, s2);
        assertEq(newTokenId2, 2);
        assertEq(logbookContract.mintedCount(), 2);
    }

    function testFailWithdrawByNonOwner() public {
        vm.prank(minter);
        logbookContract.withdraw();
    }

    function testWithdraw() public {
        vm.deal(minter, 100000000000000000);
        vm.prank(minter);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );

        vm.deal(minter2, 100000000000000000);
        vm.prank(minter2);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter2,
            v2,
            r2,
            s2
        );

        vm.prank(owner);
        logbookContract.withdraw();
        assertEq(logbookContract.getBalance(), 0);
        assertEq(owner.balance, 20000000000000000);
    }

    function testPay() public {
        vm.deal(minter, 100000000000000000);
        vm.prank(minter);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );

        vm.prank(owner);
        logbookContract.pay(minter2, 5000000000000000);
        assertEq(logbookContract.getBalance(), 5000000000000000);
        assertEq(minter2.balance, 5000000000000000);
    }

    function testFailPayByNonOwner() public {
        vm.deal(minter, 100000000000000000);
        vm.prank(minter);
        logbookContract.mintWithSignature{value: 10000000000000000}(
            minter,
            v,
            r,
            s
        );

        logbookContract.pay(minter2, 5000000000000000);
    }
}
