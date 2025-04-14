pragma solidity ^0.8.0;

contract HotelRoom{

    enum Statuses { Vacant, Occupied }
    Statuses public currentStatus;

    event Occupy(address indexed _occupant, uint _value);

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
        currentStatus = Statuses.Vacant;

    }

    modifier onlyWhileVacant {
        require(currentStatus == Statuses.Vacant, "Currently Occupied");
        _;
    }

    modifier costs (uint _amount) {
        require(msg.value >= _amount, "Not enough ether provided");
        _;

    }

    receive() external payable onlyWhileVacant costs(2 ether) {
        currentStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);

    }
}