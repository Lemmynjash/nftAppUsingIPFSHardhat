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

    mapping(uint256 => address) s_requestIdToSender;

    uint256 s_tokenCounter;

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
        s_tokenCounter = 0;
    }

    //Mint a random nft(puppy)
    function requestADog() public returns (uint256 requestId) {
        requestId = vrfCordinator2.requestRandomWords(
            //price for gas
            gasLane,
            subscriptionID,
            REQUESTCONFIRMATION,
            //maximum gas amount
            callbackGasLimit,
            NUM_WORDS
        );

        s_requestIdToSender[requestId] = msg.sender;
    }

    function fullfillRandomWords(
        uint256 requestId,
        uint256[] memory randonWords
    ) internal override {
        //here we need to mint
        //this line defines the owner of the dog
        address dogOwner = s_requestIdToSender[requestId];
        //assign this NFT a token
        //want to know how many counts we have actually minted
        uint256 new_tokenCounter = s_tokenCounter;
        s_tokenCounter = +1;
        //this line of code has minted the nft
        _safeMint(dogOwner, new_tokenCounter);
    }
}
