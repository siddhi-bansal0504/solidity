//SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract parent{

    string name;
    uint8 age;

    function getAge() public view returns(uint8){
        return age;
    }
}

contract child is parent{

    function getName() public view returns(string memory){
        return name;
    }

}


contract functionVisibility{
    string name;

    function getName() public view returns(string memory){
        return name;
    }
}