// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPReg {
    // Enum to define IP types
    enum IPType { Patent, Copyright, Trademark }

    // Struct to store IP details
    struct IP {
        IPType ipType; // Type of IP
        string title; // Title of the IP
        string desc; // Description of the IP
        address owner; // Current owner
        uint256 createdAt; // Timestamp of creation
        address[] prevOwners; // List of previous owners
    }

    // Mapping to store IPs by their unique hash
    mapping(bytes32 => IP) public ipRec;

    // Event to log IP registration
    event IPRegistered(bytes32 indexed ipHash, address indexed owner);

    // Event to log ownership transfer
    event OwnershipTransferred(bytes32 indexed ipHash, address indexed previousOwner, address newOwner);

    // Register a new IP
    function registerIP(
        bytes32 _ipHash,
        IPType _ipType,
        string memory _title,
        string memory _desc
    ) external {
        require(ipRec[_ipHash].owner == address(0), "IP already registered");

        ipRec[_ipHash] = IP({
            ipType: _ipType,
            title: _title,
            desc: _desc,
            owner: msg.sender,
            createdAt: block.timestamp,
            prevOwners: new address[](0) // Initialize empty array for previous owners
        });

        emit IPRegistered(_ipHash, msg.sender);
    }

    // Transfer ownership of an IP
    function transferOwn(bytes32 _ipHash, address _newOwner) external {
        require(ipRec[_ipHash].owner == msg.sender, "You are not the owner");
        require(_newOwner != address(0), "Invalid address");

        // Add current owner to previousOwners array
        ipRec[_ipHash].prevOwners.push(msg.sender);

        // Update owner
        ipRec[_ipHash].owner = _newOwner;

        emit OwnershipTransferred(_ipHash, msg.sender, _newOwner);
    }

    // Get IP details
    function getIPDetails(bytes32 _ipHash) external view returns (
        IPType ipType,
        string memory title,
        string memory description,
        address owner,
        uint256 createdAt,
        address[] memory previousOwners
    ) {
        IP memory ip = ipRec[_ipHash];
        require(ip.owner != address(0), "IP not found");

        return (
            ip.ipType,
            ip.title,
            ip.desc,
            ip.owner,
            ip.createdAt,
            ip.prevOwners
        );
    }
}