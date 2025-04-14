//SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

contract structSample{
    address public Simplilearn;

    constructor() public {

        Simplilearn = msg.sender;

    }

    modifier onlySimplilearn(){

        require(msg.sender == Simplilearn); //only Simplilearn is authorized to contro and make 
        //changes but as it is public it will be visible to everyone

        _;

    }

    struct learner{
        string name;
        uint8 age;
    }
    //mapping (key => value) mapping name
    mapping (uint => learner) public learners;
    //1 => ("Alice",40)
    //2 => ("Tom", 25)
    //3 => ("Jerry", 34)
    
    function setLearnerDetails(uint _key,string memory _name, uint8 _age) public onlySimplilearn{
        learners[_key].name=_name;
        learners[_key].age=_age;
        //learners[1].name="Alice";
        //learners[1].age=40
    }

    function getLearnerdetails(uint _key) public view returns(string memory, uint8 ){
        return(learners[_key].name,learners[_key].age);
    }
}
