// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedInsurance {
    address public insurer;

    enum PolicyStatus { Active, Expired, Claimed }
    
    struct Policy {
        uint256 policyId;
        address policyholder;
        uint256 premiumAmount;
        uint256 payoutAmount;
        uint256 validUntil;
        PolicyStatus status;
    }

    mapping(uint256 => Policy) public policies;
    mapping(address => uint256[]) public userPolicies;
    uint256 public policyCounter;

    event PolicyIssued(uint256 policyId, address policyholder, uint256 premiumAmount, uint256 payoutAmount, uint256 validUntil);
    event PremiumPaid(uint256 policyId, address policyholder);
    event ClaimSubmitted(uint256 policyId, address policyholder);
    event ClaimApproved(uint256 policyId, address policyholder, uint256 payoutAmount);

    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only insurer can perform this action");
        _;
    }

    modifier onlyPolicyholder(uint256 policyId) {
        require(policies[policyId].policyholder == msg.sender, "Only policyholder can perform this action");
        _;
    }

    constructor() {
        insurer = msg.sender;
    }

    function issuePolicy(address _policyholder, uint256 _premiumAmount, uint256 _payoutAmount, uint256 _validUntil) public onlyInsurer {
        policyCounter++;
        policies[policyCounter] = Policy(policyCounter, _policyholder, _premiumAmount, _payoutAmount, _validUntil, PolicyStatus.Active);
        userPolicies[_policyholder].push(policyCounter);
        emit PolicyIssued(policyCounter, _policyholder, _premiumAmount, _payoutAmount, _validUntil);
    }

    function payPremium(uint256 policyId) public payable onlyPolicyholder(policyId) {
        require(msg.value == policies[policyId].premiumAmount, "Incorrect premium amount");
        emit PremiumPaid(policyId, msg.sender);
    }

    function submitClaim(uint256 policyId) public onlyPolicyholder(policyId) {
        require(policies[policyId].status == PolicyStatus.Active, "Policy is not active");
        require(block.timestamp <= policies[policyId].validUntil, "Policy has expired");
        policies[policyId].status = PolicyStatus.Claimed;
        emit ClaimSubmitted(policyId, msg.sender);
    }

    function approveClaim(uint256 policyId) public onlyInsurer {
        require(policies[policyId].status == PolicyStatus.Claimed, "Claim not submitted or already processed");
        policies[policyId].status = PolicyStatus.Expired;
        payable(policies[policyId].policyholder).transfer(policies[policyId].payoutAmount);
        emit ClaimApproved(policyId, policies[policyId].policyholder, policies[policyId].payoutAmount);
    }
}
