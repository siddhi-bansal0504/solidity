// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public owner;

    bool public votingOpen;
    string public electionName;
    
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedCandidateId;
    }

    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    
    uint[] public candidateIds;
    address[] public voterAddresses;

    event VoterRegistered(address voter);
    event CandidateAdded(uint candidateId, string name);
    event VoteCaste(address voter, uint candidateId);
    event VotingStatusChanged(bool status);
    event ElectionReset();

    modifier onlyOwner() {
        require(msg.sender==owner, "Only owner can perform this action");
        _;
    }

    modifier votingIsOpen() {
        require(votingOpen, "Voting is currently closed");
        _;
    }

    constructor(string memory _electionName) {
        owner = msg.sender;
        electionName = _electionName;
        votingOpen = false;
    }

    //Register a voter
    function registerVoter(address _voterAddress) public onlyOwner {
        require(!voters[_voterAddress].isRegistered, "Voter already registered");

        voters[_voterAddress] = Voter({
            isRegistered: true,
            hasVoted: false,
            votedCandidateId: 0
        });

        voterAddresses.push(_voterAddress);
        emit VoterRegistered(_voterAddress);
    }

    //add a candidate
    function addCandidate(string memory _name) public onlyOwner {
        uint candidateId = candidateIds.length + 1;

        candidates[candidateId] = Candidate({
            id: candidateId,
            name: _name,
            voteCount: 0
        });

        candidateIds.push(candidateId);
        emit CandidateAdded(candidateId, _name);
    }

    //caste a vote
    function vote(uint _candidateId) public votingIsOpen {
        require(voters[msg.sender].isRegistered, "Voter not registered");
        require(!voters[msg.sender].hasVoted, "already voted");
        require(_candidateId > 0 && _candidateId <= candidateIds.length, "Invalid candidateId");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedCandidateId = _candidateId;
        candidates[_candidateId].voteCount++;

        emit VoteCaste(msg.sender, _candidateId);

    }

    //toggle voting status
    function toggleVotingStatus(bool _status) public onlyOwner {
        votingOpen = _status;
        emit VotingStatusChanged(_status);
    }

    //get election results
    function getResults() public view returns (Candidate[] memory) {
        Candidate[] memory result = new Candidate[](candidateIds.length);

        for (uint i = 0; i < candidateIds.length; i++){
            result[i] = candidates[candidateIds[i]];
        }

        return result;
    }

    //get winner
    function getWinner() public view returns (Candidate memory winner) {
        require(!votingOpen, "Voting is still open");
        require(candidateIds.length > 0, 'No candidates');

        winner = candidates[candidateIds[0]];

        for(uint i =1; i < candidateIds.length; i++) {
            if (candidates[candidateIds[i]].voteCount > winner.voteCount) {
                winner = candidates[candidateIds[i]];

            }
        }

        return winner;
    }

    function resetElection() public onlyOwner {
        require(!votingOpen, "Cannot reset while voting is open");

        for (uint i=0;i < voterAddresses.length; i++) {
            delete voters[voterAddresses[i]];
        }

        for (uint i=0; i < candidateIds.length; i++) {
            delete candidates[candidateIds[i]];
        }

        delete candidateIds;
        delete voterAddresses;

        emit ElectionReset();
    }
}