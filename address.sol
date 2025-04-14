//SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract Money{

    address alice = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    //balance --> check the balance of the addredd
    //transfer --> used to transfer/send to the address

    function getMoney() public payable {}

    function TransferMoney() public {
        payable(alice).transfer(address(this).balance); //this-->smart contract address
    }

     /*function TransferMoney(uint _amount) public {
        payable(alice).transfer(_amount);
    }*/

    //fallback() external payable{}-->to enable external wallet to transfer money to SC address

    
}