//SPDX-License-Identifier: MIT

pragma solidity ^0.6.10;

contract errorhandlingsample{

      

      uint balance = 100;

      function deductBal(uint _amount) public returns(uint){

        if(_amount < 2){

            revert("Input amount is not valid");

        }

        balance = balance - _amount;

        return balance;

      }

      function deductBal1(uint _amount) public returns(uint){

        require(_amount>1,"Input amount is not valid");

        balance = balance - _amount;

        return balance;

      }

      function deductBal2(uint _amount) public returns(uint){

        assert(_amount>1);

        balance = balance - _amount;

        return balance;

      }

}