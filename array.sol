//SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract arraySample{

    //aray --> fixed and dynamic
    //fixed length array
    //age[0]=35, age[1]=34......age[49]=29
    uint8[50] age; //50--size of array

    function setData(uint8 _index, uint8 _value) public {
        age[_index] = _value;
    }

    function getData(uint _index) public view returns(uint8){
        return age[_index];
    }

    //Dynamic Array
    uint[] phoneNumber;

    function setDynamicArray (uint _phoneno) public {
        phoneNumber.push(_phoneno);
    }

    function getDynamicArray(uint8 _index) public view returns(uint){
        return phoneNumber[_index];

    }
    
}