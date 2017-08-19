a solidity ^0.4.0;
contract VoteDemo{
    //define the voter
    struct Voter{
        uint weight;
        address delegate;
        bool voted;
        uint vote;
    }
    
    //define the vote topic
    struct Proposal{
        bytes32 name;
        uint voteCount;
    }
    
    //voter initiator
    address public chairPerson;
    
    //all the voters
    mapping(address => Voter) public voters;
    
    //all the proposal
    Proposal[] public proposals;
    
    //construct function to initialize the posposals
    function VoteDemo(bytes32[] proposalName){
        chairPerson = msg.sender;
        voters[msg.sender].weight = 1;
        
        for(uint i = 0; i < proposalName.length; i++){
            proposals.push(Proposal({name:proposalName[i], voteCount:0}));
        }
    }
    
    function giveRightToVote(address addr) public{
        //only the chairman can add voters
        require(msg.sender == chairPerson && voters[addr].voted == false);
        voters[addr].weight = 1;
    }
    
    function delegateVoteRigth(address addr) public{
        //voter must still have vote right and cannot assgin to themselves
        require(voters[msg.sender].voted == false && msg.sender != addr);
        
        //the delegater must have the right to vote
        require(voters[addr].weight != 0 || voters[addr].voted == true);
        while(voters[addr].delegate != address(0)){
            addr = voters[addr].delegate;
            if(addr == msg.sender){
                revert();
            }
        }
        
        //transfer the vote right
        voters[msg.sender].delegate = addr;
        voters[msg.sender].voted = true;
        if(voters[addr].voted = true){
            proposals[voters[addr].vote].voteCount += voters[msg.sender].weight;
        }
        else{
            voters[addr].weight += voters[msg.sender].weight;
        }
    }
    
    function vote(uint pid) public{
        //check whether still have vote right
        require(voters[msg.sender].voted == false && voters[msg.sender].weight > 0);
        //pid is a valid propsals
        require(pid < proposals.length);
        
        voters[msg.sender].voted = true;
        uint weight = voters[msg.sender].weight;
        voters[msg.sender].weight = 0;
        voters[msg.sender].vote = pid;
        proposals[pid].voteCount += weight;
    }
    
    function winner() constant returns(bytes32 winnerName){
        uint winnerCount;
        uint winnerId;
        for(uint i = 0; i < proposals.length; i++){
            if(proposals[i].voteCount > winnerCount){
                winnerCount = proposals[i].voteCount;
                winnerId = i;
            }
        }
        winnerName = proposals[winnerId].name;
    }
    
    
}
