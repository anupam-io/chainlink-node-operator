// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.6/Oracle.sol";
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.6/vendor/Ownable.sol";

import "erc1155-nft-token-and-holder/contracts/TokenHolder.sol";

contract APIConsumer is ChainlinkClient, Ownable {
    uint256 private constant ORACLE_PAYMENT = 1 * LINK;
    address public tokenHolderAddr;

    event RequestNFTClaimFullfilled(
        bytes32 indexed requestId,
        bool indexed _result
    );

    constructor(address _tokenHolderAddr) public Ownable() {
        setPublicChainlinkToken();
        tokenHolderAddr = _tokenHolderAddr;
    }

    mapping(uint256 => mapping(address => string)) ledger;

    function requestNFTClaim(
        address _oracle,
        string memory _jobId,
        string memory _tokenSymbol
    ) public onlyOwner {
        Chainlink.Request memory req =
            buildChainlinkRequest(
                stringToBytes32(_jobId),
                address(this),
                this.fulfillEthereumPrice.selector
            );
        req.add("get", "http://localhost:3000/nftclaim/:user/:pool/:uniq");
        req.add("path", "number");
        req.addInt("times", 1000);
        uint256 requestId =
            sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
        ledger[requestId][msg.sender] = _tokenSymbol;
    }

    function fulfillNFTClaim(bytes32 _requestId, bool _result)
        public
        recordChainlinkFulfillment(_requestId)
    {
        if (_result) {
            emit RequestNFTClaimFullfilled(_requestId, _result);
            TokenHolder(tokenHolderAddr).rewardNFT();
        }
    }

    function stringToBytes32(string memory source)
        private
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }
}
