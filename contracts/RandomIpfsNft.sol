// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomIpfsNft is ERC721URIStorage, VRFConsumerBaseV2 {
    //why use immutable because its gas efficient
    //plus we are going to use the variable once
    VRFCoordinatorV2Interface immutable i_vrfCordinator2;
    bytes32 public immutable i_gasLane;
    uint64 public immutable i_subscriptionID;
    uint16 public constant REQUESTCONFIRMATION = 7;
    uint32 public immutable i_callbackGasLimit;
    uint16 public constant NUM_WORDS = 3;
    uint256 public constant MAX_CHANCE_VALUE = 100;

    mapping(uint256 => address) public s_requestIdToSender;

    uint256 public s_tokenCounter;
    string[3] public s_dogTokenUris;
    //nfts will be called Random IPFS NFT and NFT token is called RIN
    constructor(
        address vrfCoordinator2,
        bytes32 gasLane,
        uint64 subscriptionID,
        uint32 callbackGasLimit,
        string[3] memory dogTokenUris
    //1. st benard
    //2. pug
    //3. shiba inu
    ) ERC721("Random IPFS NFT", "RIN") VRFConsumerBaseV2(vrfCoordinator2) {
        i_vrfCordinator2 = VRFCoordinatorV2Interface(vrfCoordinator2);
        i_gasLane = gasLane;
        i_subscriptionID = subscriptionID;
        i_callbackGasLimit = callbackGasLimit;
        s_tokenCounter = 0;
        s_dogTokenUris = dogTokenUris;
    }

    //Mint a random nft(puppy)
    function requestADog() public returns (uint256 requestId) {
        requestId = i_vrfCordinator2.requestRandomWords(
        //price for gas
            i_gasLane,
            i_subscriptionID,
            REQUESTCONFIRMATION,
        //maximum gas amount
            i_callbackGasLimit,
            NUM_WORDS
        );

        s_requestIdToSender[requestId] = msg.sender;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        //here we need to mint
        //this line defines the owner of the dog
        address dogOwner = s_requestIdToSender[requestId];
        //assign this NFT a token
        //want to know how many counts we have actually minted
        uint256 new_tokenCounter = s_tokenCounter;
        s_tokenCounter = s_tokenCounter + 1;
        //this line of code has minted the nft
        //get the breed of this dog
        uint256 moddedRng = randomWords[0] % MAX_CHANCE_VALUE;
        uint256 breed = getBreedFromModdedPug(moddedRng);
        _safeMint(dogOwner, new_tokenCounter);
        //after minting I am going to set a token URI
        _setTokenURI(new_tokenCounter, s_dogTokenUris[breed]);
    }

    function getChanceArray() public pure returns (uint256[3] memory) {
        //for instance
        // 0-9 =st.benard (type of a dog)
        // 10-29 =pug
        // 30-99=shiba inu
        return [10, 30, MAX_CHANCE_VALUE];
    }

    function getBreedFromModdedPug(uint256 moddedRng) public pure returns (uint256){
        uint256 cumulativeSum = 0;
        //uint256 i = 0;
        uint256[3] memory chanceArray = getChanceArray();
        for (uint256 i = 0; i < chanceArray.length; i++) {
            if (moddedRng >= cumulativeSum && moddedRng < cumulativeSum + chanceArray[i]) {
                return i;
            }
            cumulativeSum = cumulativeSum + chanceArray[i];
        }
        //return i;
    }
}
