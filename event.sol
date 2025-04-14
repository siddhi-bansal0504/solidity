//SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract valueAlert{

    uint price = 100;

    //define the event 
    event priceEvent (bool returnvalue);

    function bid (uint _amount) public returns(bool){
        if(_amount>price){
               //trigger the event
            emit priceEvent(true);
        }
    }  

}

