// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract logbook is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string public metadataFolderURI;
    mapping(address => uint256) public minted;
    uint256 public constant price = 0.01 ether;
    address public constant signer = 0x3EDfd44082A87CF1b4cbB68D6Cf61F0A40d0b68f;
    bool public mintActive;
    uint256 public freeMints;
    uint256 public mintsPerAddress;
    string public openseaContractMetadataURL;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _metadataFolderURI,
        uint256 _freeMints,
        uint256 _mintsPerAddress,
        string memory _openseaContractMetadataURL,
        bool _mintActive
    ) ERC721(_name, _symbol) {
        metadataFolderURI = _metadataFolderURI;
        freeMints = _freeMints;
        mintsPerAddress = _mintsPerAddress;
        openseaContractMetadataURL = _openseaContractMetadataURL;
        mintActive = _mintActive;
    }

    function setMetadataFolderURI(string calldata folderUrl) public onlyOwner {
        metadataFolderURI = folderUrl;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );
        return
            string(
                abi.encodePacked(metadataFolderURI, Strings.toString(tokenId))
            );
    }

    function contractURI() public view returns (string memory) {
        return openseaContractMetadataURL;
    }

    function isMintFree() public view returns (bool) {
        return (freeMints > _tokenIds.current());
    }

    function mintWithSignature(
        address minter,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public payable returns (uint256) {
        require(mintActive == true, "mint is not active rn..");
        require(tx.origin == msg.sender, "dont get Seven'd");
        require(minter == msg.sender, "you have to mint for yourself");
        require(
            minted[msg.sender] < mintsPerAddress,
            "only 1 mint per wallet address"
        );

        if (!isMintFree()) {
            require(msg.value == price, "This mint costs 0.01 eth"); // TODO: set price
        }

        bytes32 payloadHash = keccak256(abi.encode(minter));
        bytes32 messageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", payloadHash)
        );

        address actualSigner = ecrecover(messageHash, v, r, s);

        require(actualSigner != address(0), "ECDSA: invalid signature");
        require(actualSigner == signer, "Invalid signer");

        _tokenIds.increment();

        minted[msg.sender]++;

        uint256 tokenId = _tokenIds.current();
        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    function mintedCount() external view returns (uint256) {
        return _tokenIds.current();
    }

    function setMintActive(bool _mintActive) public onlyOwner {
        mintActive = _mintActive;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function pay(address payee, uint256 amountInEth) public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance >= amountInEth, "We dont have that much to pay!");
        payable(payee).transfer(amountInEth);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
