//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Endgame} from "../src/Endgame.sol";

contract DeployEndgame {
    function deploy() external returns {
        vm.startbroadcast();
        Endgame endGame = new Endgame();
        vm.stopbroadcast();
        return endGame;
    }
}
