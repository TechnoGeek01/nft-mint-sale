// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract INFtoken is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public max_supply = 5;
    uint256 public nft_mint_price = 0.01 ether;

    string public constant TOKEN_URI = ""; // Token uri of our nft

    constructor() ERC721("Puppy", "PPY") {}

    function tokenURI(
        uint256 /*tokenId*/
    ) public pure override returns (string memory) {
        // require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return TOKEN_URI;
    }

    // Anyone can mint nft from the contract if they pay the mint price of 0.01 ether.
    // Max supply of nfts that can ever be minted from this contract is 5.
    function safeMint(address to) public payable {
        require(totalSupply() < max_supply, "Max supply reached!!!");
        require(msg.value == nft_mint_price, "Nft mint price is 0.01 ether");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // Only the owner can withdraw the sales amount from the contract.
    function withdraw() public onlyOwner {
        require(
            address(this).balance > 0,
            "There is no ether balance in the contract"
        );
        payable(owner()).transfer(address(this).balance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
