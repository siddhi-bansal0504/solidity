//SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract datatypes{

    //define datatypes
    //unsigned integer --> +ve values
    //signed integer --> +ve and -ve values
    //uint256 --> 0.1KB
    //UINT8 --> 0.001KB

    uint8 age;
    uint16 height;
    uint64 amount;
    int64 balance;

    //string datatype --> bytes and string 9Text)
    bytes5 name="alice"; //predefined
    string country;

    //bool datatype-->True or False
    bool flag;
}