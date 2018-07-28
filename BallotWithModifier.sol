pragma solidity ^0.4.24;

contract BallotWithModifier {
    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
        address  delegate;
    }

    struct Proposal {
        uint voteCount;
    }

    enum Stage {Init, Reg, Vote, Done}
    Stage public stage = Stage.Init;

    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;

    event votingCompleted();

    uint startTime;

    modifier validStage(Stage reqStage) {
        require(stage == regStage);
        _;
    }

    constructor(uint8 _numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        proposals.length = _numProposals;
        stage = Stage.Reg;
        startTime = now;
    }

    function register(address toVoter) public validStage(Stage.Reg) {
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        if (now > (startTime + 30 seconds)) {
            stage = Stage.Vote;
        }
    }

    function vote(uint8 toProposal) public validStage(Stage.Vote) {
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
        if (now > startTime + 30 seconds)) {
            stage = Stage.Done;
            emit votingCompleted;
        }
    }

    function winningProposal() public validStage(Stage.Done) constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
        assert (winningVoteCount > 0);
    }
}
