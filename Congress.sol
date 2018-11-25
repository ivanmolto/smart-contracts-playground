pragma solidity ^0.4.16;

contract owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract tokenRecipient {
    event receivedEther(address sender, uint amount);
    event receivedTokens(address _from, uint256 _value, address _token, bytes _extraData);

    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
        Token t = Token(_token);
        require(t.transferFrom(_from, this, _value));
        emit receivedTokens(_from, _value, _token, _extraData);
    }

    function () payable public {
        emot receivedEther(msg.sender, msg.value);
    }
}

interface Token {
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

contract Congress is owned, tokenRecipient {
    uint public minimumQuorum;
    uint public debatingPeriodInMinutes;
    int public majorityMargin;
    Proposal[] public proposals;
    uint public numProposals;
    mapping(address => uint) public memberId;
    Member[] public members;

    event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
    event Voted(uint proposalID, bool position, address voter, string justification);
    event ProposalTallied(uint proposalID, int result, uint quorum, bool active);
    event MembershipChanged(address member, bool isMember);
    event ChangeOfRules(uint newMinimnumQuorum, uint newDebatingPeriodInMinutes, int newMajority);

    struct Proposal {
        address recipient;
        uint amount;
        string description;
        uint minExecutionDate;
        bool executed;
        bool proposalPassed;
        uint numberOfVotes;
        int currentResult;
        bytes32 proposalHash;
        Vote[] votes;
        mapping (address => bool) voted;
    }

    struct Member {
        address member;
        string name;
        uint memberSince;
    }

    struct Vote {
        bool inSupport;
        address voter;
        string justification;
    }

    modifier onlyMembers {
        require(memberId[msg.sender] != 0);
        _;
    }


    function Congress(uint minimumQuorumForProposals, uint minutesForDebate, int marginOfVotesForMajority) payable public {
        changeVotingRules(minimumQuorumForProposals, minutesForDebate, marginOfVotesForMajority);

        addMember(0, "");
        addMember(owner, 'founder');
    }

    function addMember(address targetMember, string memberName) onlyOwner public {
        uint id = memberId[targetMember];
        if (id == 0) {
            memberId[targetMember] = members.length;
            id = members.length++;
        }

        members[id] = Member({member: targetMember, memberSince: now, name: memberName});
        emit MembershipChanged(targetMember, true);
    }

    function removeMember(address targetMember) onlyOwner public {
        require(memberId[targetMember] !=0);

        for (uint i = memberId[targetMember]; i < members.length - 1; i++) {
            members[i] = members[i+1];
        }
        delete members[members.length - 1];
        members.length--;
    }

    function changeVotingRules(uint minimumQuorumForProposals, uint minutesForDebate, int marginOfVotesForMajority) onlyOwner public {
        minimumQuorum = minimumQuorumForProposals;
        debatingPeriodInMinutes = minutesForDebate;
        majorityMargin = marginOfVotesForMajority;

        emit ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, majorityMargin);
    }

    function newProposal(address beneficiary, uint weiAmount, string jobDescription, bytes transactionBytecode) onlyMembers public returns (uint proposalID) {
        proposalID = proposals.length++;
        Proposal storage p = proposals[ProposalId];
    }
}
