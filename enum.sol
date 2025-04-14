//SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract enumsample{

    enum PizzaSize {SMALL, MEDIUM, LARGE}
    PizzaSize choice;

    function setLarge() public {
        choice = PizzaSize.LARGE;
    }

    function getChoice() public view returns(PizzaSize){
        return choice;
    }

}