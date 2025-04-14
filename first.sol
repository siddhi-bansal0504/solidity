pragma solidity ^0.5.1; //version of solidity

contract SimpleStorage{ //creating contract

    uint public storedata;

    function set(uint x) public { //write function
        storedata=x;
    }

    function get() public view returns(uint){ //read function
        return storedata;                     //view means data will not be changed

    }
    /*welcome to the 
    blochchain session*/
}