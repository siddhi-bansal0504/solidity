// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract HealthCare {

    string public patientName;

    string public healthStatus;

    // Function to register a patient

    function setPatient(string memory _name) public {

        patientName = _name;

        healthStatus = "Healthy"; // Default status when added

    }

    // Function to update health status

    function updateHealthStatus(string memory _status) public {

        healthStatus = _status;

    }

    // Function to get patient details

    function getPatient() public view returns (string memory, string memory) {

        return (patientName, healthStatus);

    }

}