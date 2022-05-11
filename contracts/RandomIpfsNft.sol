// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomIpfsNft is ERC721URIStorage, VRFConsumerBaseV2 {
    //why use immutable because its gas efficient
    //plus we are going to use the variable once
    VRFCoordinatorV2Interface immutable vrfCordinator2;
    bytes32 immutable gasLane;
    uint64 immutable subscriptionID;
    uint16 constant REQUESTCONFIRMATION = 7;
    uint32 immutable callbackGasLimit;
    uint16 constant NUM_WORDS = 3;

    //nfts will be called Random IPFS NFT and NFT token is called RIN
    constructor(
        address vrfCordinator2,
        bytes32 gasLane,
        uint64 subscriptionID,
        uint32 callbackGasLimit
    ) ERC721("Random IPFS NFT", "RIN") VRFConsumerBaseV2(vrfCordinator2) {
        vrfCordinator2 = VRFCoordinatorV2Interface(vrfCordinator2);
        gasLane = gasLane;
        subscriptionID = subscriptionID;
        callbackGasLimit = callbackGasLimit;
    }

    //Mint a random nft(puppy)
    function requestADog() public returns (uint256 requestId) {
        requestId=vrfCordinator2.requestRandomWords(
            gasLane,
            subscriptionID,
            REQUESTCONFIRMATION,
            callbackGasLimit,
            NUM_WORDS,
        );
    }
}
