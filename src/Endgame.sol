// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Note: The AggregatorV3Interface might be at a different location than what was in the video!
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error Engame_NiceTry();

contract Endgame {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressofdepositor;
    address[] public depositor;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public constant MinimumUSD=15e18;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed)
    }

    function deposit() public payable {
        require(msg.value.getConversionRate(s_priceFeed)>=MinimumUSD, "Less than minimum");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "less than minimum");
        addressofdepositor[msg.sender] += msg.value;
        depositor.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
       return s_priceFeed.version();
    }

    modifier onlyOwner() {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NiceTry();
        _;
    }

    function withdraw() public onlyOwner {
        for (uint256 depositorIndex = 0; depositorIndex < depositor.length; depositorIndex++) {
            address depositors = depositor[depositorIndex];
            addressofdepositor[depositors] = 0;
        }
        depositor = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }
}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly