// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPRegistry {
    // Enum to define IP types
    enum IPType { Patent, Copyright, Trademark }

    // Enum to define IP status
    enum Status { Active, Expired, Disputed }

    // Struct to store IP details
    struct IP {
        IPType ipType; // Type of IP (Patent, Copyright, Trademark)
        string title; // Title of the IP
        string description; // Description of the IP
        address owner; // Current owner of the IP
        uint256 createdDate; // Timestamp when the IP was created
        uint256 updatedDate; // Timestamp when the IP was last updated
        Status status; // Current status of the IP (Active, Expired, Disputed)
        string uri; // URI for external metadata (e.g., IPFS hash)
        address[] previousOwners; // List of previous owners
    }

    // Mapping to store IP records by their hash
    mapping(bytes32 => IP) public ipRecords;

    // Mapping to store all IPs owned by an address
    mapping(address => bytes32[]) public ownerIPs;

    // Event to log IP registration
    event IPRegistered(bytes32 indexed ipHash, address indexed owner);

    // Event to log ownership transfer
    event OwnershipTransferred(bytes32 indexed ipHash, address indexed previousOwner, address newOwner);

    // Event to log status updates
    event StatusUpdated(bytes32 indexed ipHash, Status newStatus);

    // Event to log metadata updates
    event MetadataUpdated(bytes32 indexed ipHash, string newUri);

    // Function to register a new IP
    function registerIP(
        bytes32 _ipHash,
        IPType _ipType,
        string memory _title,
        string memory _description,
        string memory _uri
    ) external {
        require(ipRecords[_ipHash].owner == address(0), "IP already exists");

        ipRecords[_ipHash] = IP({
            ipType: _ipType,
            title: _title,
            description: _description,
            owner: msg.sender,
            createdDate: block.timestamp,
            updatedDate: block.timestamp,
            status: Status.Active,
            uri: _uri,
            previousOwners: new address[](0)
        });

        ownerIPs[msg.sender].push(_ipHash);
        emit IPRegistered(_ipHash, msg.sender);
    }

    // Function to transfer ownership of an IP
    function transferOwnership(bytes32 _ipHash, address _newOwner) external {
        IP storage ip = ipRecords[_ipHash];
        require(ip.owner == msg.sender, "Not owner");
        require(_newOwner != address(0), "Invalid address");

        ip.previousOwners.push(msg.sender);
        ip.owner = _newOwner;
        ip.updatedDate = block.timestamp;

        ownerIPs[_newOwner].push(_ipHash);
        emit OwnershipTransferred(_ipHash, msg.sender, _newOwner);
    }

    // Function to update the status of an IP
    function updateStatus(bytes32 _ipHash, Status _newStatus) external {
        IP storage ip = ipRecords[_ipHash];
        require(ip.owner == msg.sender, "Not owner");

        ip.status = _newStatus;
        ip.updatedDate = block.timestamp;
        emit StatusUpdated(_ipHash, _newStatus);
    }

    // Function to update the metadata URI of an IP
    function updateMetadata(bytes32 _ipHash, string memory _newUri) external {
        IP storage ip = ipRecords[_ipHash];
        require(ip.owner == msg.sender, "Not owner");

        ip.uri = _newUri;
        ip.updatedDate = block.timestamp;
        emit MetadataUpdated(_ipHash, _newUri);
    }

    // Function to get IP details
    function getIPDetails(bytes32 _ipHash) external view returns (
        IPType ipType,
        string memory title,
        string memory description,
        address owner,
        uint256 createdDate,
        uint256 updatedDate,
        Status status,
        string memory uri,
        address[] memory previousOwners
    ) {
        IP storage ip = ipRecords[_ipHash];
        require(ip.owner != address(0), "IP not found");

        return (
            ip.ipType,
            ip.title,
            ip.description,
            ip.owner,
            ip.createdDate,
            ip.updatedDate,
            ip.status,
            ip.uri,
            ip.previousOwners
        );
    }

    // Function to get all IPs owned by an address
    function getOwnerIPs(address _owner) external view returns (bytes32[] memory) {
        return ownerIPs[_owner];
    }
}