// SPDX-Licence-Identifier: UNLICENCED
pragma solidity >=0.5.0 < 0.9.0;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public manager;
    uint public deadline;
    uint public minimumContribution;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

    struct Request {
        uint value; // amount the manager want to give
        string description; // why manager want to give
        address payable recipient; // to which manager want to give the money
        bool completed; // for checking is this request is in pending or not
        uint noOfvoters; // counting how many user agreed to contribute (or voted) for this request
        mapping(address => bool) voters; // taking record of each user who agreed or disagreed on this request
    }

    mapping(uint => Request) public requests; // it carry requests for charity or different things
    uint public numRequests; // 

    // here the manager initially assign the minimum target and
    // the deadline to achieve the target
    constructor(uint _target, uint _deadline) public{
        target = _target;
        // timestamp comes in unix format
        deadline = block.timestamp + _deadline; // 10sec + 360sec (60*60)
        minimumContribution = 100 wei;

        // as the manager deploy the smart contract so it will assign the sender( or manager) address to manager
        manager = msg.sender; 
    }

    // to send the ether by the contributors
    function senderEth() public payable {
        // to check that the deadline is crossed or not
        // if crossed then printed we printed "Deadline has passed"
        require(block.timestamp < deadline, "Deadline has passed");

        // to check the amount send is above minimumContribution
        // if not then print "Minimum Contribution is not met!"
        require(msg.value >= minimumContribution,"Minimum Contribution is not met!");

        // if check the new user. If new user add the amount then increase the noOfContributors
        if(contributors[msg.sender] == 0){
            noOfContributors++;
        }

        // adding the amount respective of its address. and adding bcz if one user made more than one transaction
        contributors[msg.sender] += msg.value;
        // increasing the raisedAmount
        raisedAmount += msg.value;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    // if user want the refund
    function refund() public {
        // checking if the deadline is crossed or not and target value is achieved or not
        require(block.timestamp > deadline && raisedAmount < target, "You are not eligible for the refund");
        // checking if it is a valid user or not (or he previously contributed or not)
        require(contributors[msg.sender] > 0, "You are not eligible for the refund");

        // creating the variable user to get the sender address with payable
        // making user payable because we have to transfer the collected money to that user
        address payable user = payable(msg.sender);
        // sending the total gathered money to the user 
        contributors[msg.sender] = 0;
        user.transfer(contributors[msg.sender]);
    }

    // modifier so that it can be used in functions so that those functions can only be used by manager
    modifier onlyManager(){
        require(msg.sender == manager, "Only manager can access this call function");
        _;
    }
    
    // creating request and adding the contents of the struct in those variables
    function createRequest(string memory _description, uint _value, address payable _recipient) public onlyManager{
        // creating object of the struct
        Request storage _newRequest = requests[numRequests];
        numRequests++;
        _newRequest.description = _description;
        _newRequest.value = _value;
        _newRequest.recipient = _recipient;
        _newRequest.completed = false;
        _newRequest.noOfvoters = 0; 
    }

    // taking vote Request or taking the vote of contributors
    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0,"You must be a contributor");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false,"You already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfvoters++;
    }

    // for manager to send the money to the recipient
    function makePayment(uint _requestNo) public onlyManager{
        require(raisedAmount > target,"Target amount is not achieved yet!");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false,"The request has been completed");
        require(thisRequest.noOfvoters > noOfContributors/2,"Majority does not support");
        // raisedAmount-=thisRequest.value; // not required
        thisRequest.recipient.transfer(thisRequest.value); // transfering money to the recipient
        thisRequest.completed=true;        
    }
}
