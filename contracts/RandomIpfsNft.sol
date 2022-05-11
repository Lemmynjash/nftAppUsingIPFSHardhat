// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomIpfsNft is ERC721URIStorage, VRFConsumerBaseV2 {
    //why use immutable because its gas efficient
    //plus we are going to use the variable once
    VRFCoordinatorV2Interface immutable vrfCordinator2;

    //nfts will be called Random IPFS NFT and NFT token is called RIN
    constructor(address vrfCordinator2) ERC721("Random IPFS NFT", "RIN") {
        vrfCordinator2 = VRFCoordinatorV2Interface(vrfCordinator2);
    }

    //Mint a random nft(puppy)
    function requestADog() public returns (uint256 requestId) {}
}
