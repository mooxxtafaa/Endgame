//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Endgame} from "../src/Endgame.sol";
import {DeployEndgame} from "../script/DeployEndgame.s.sol";

contract EndgameTest is Test {
    Endgame endGame;

    function setUp() external {
        DeployEndGame deployendGame = new DeployEndgame();
        endGame = deployendGame.run();
    }

    function testMinimumUSDis15() public view {
        assertEq(endGame.MinimumUSD(), 15e18);
    }
}
