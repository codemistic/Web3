pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    string public managerName;
    address[] public players;
    string public lotteryName;
    string public lotteryOrganization;
    uint public ticketPrice;
    string public resultDate;
    bool public isStarted;
    address[] public winners;

    function Lottery(string name) public {
        manager = msg.sender;
        managerName = name;
        ticketPrice = 0 ether;
        isStarted = false;
    }

    function start(string LName, string LOrganization, uint TPrice, string RDate) public restricted{
        require(isStarted == false);
        isStarted = true;
        lotteryName = LName;
        lotteryOrganization = LOrganization;
        ticketPrice = (TPrice * 1000000000000000000);
        resultDate = RDate;
        winners = new address[](0);
    }

    function enter() public payable {
        require(isStarted == true);
        require(msg.value == ticketPrice);

        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

  function pickWinner() public restricted {
        require(isStarted == true);
        require(players.length > 2);

        uint index = random() % players.length;
        players[index].transfer(this.balance/2);
        winners.push(players[index]);
        for (uint i = index; i<players.length-1; i++){
            players[i] = players[i+1];
        }
        delete players[players.length-1];
        players.length--;

        uint indexSecond = random() % players.length;
        players[indexSecond].transfer(this.balance/2);
        winners.push(players[indexSecond]);
        for (uint ii = indexSecond; ii<players.length-1; ii++){
            players[ii] = players[ii+1];
        }
        delete players[players.length-1];
        players.length--;

        uint indexThird = random() % players.length;
        players[indexThird].transfer(this.balance/2);
        winners.push(players[indexThird]);
        manager.transfer(this.balance);
        players = new address[](0);
        isStarted = false;
    }

    function cancelLottery() public restricted{
        require(isStarted == true);
        for(uint i=0;i<players.length;i++){
            players[i].transfer(ticketPrice);
        }
        players = new address[](0);
        isStarted = false;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }

    function getLastWinners() public view returns (address[]){
        return winners;
    }

    function getAboutLottery() public view returns(string, string, string, address, string, uint, address[]){
        require(isStarted == true);
        return (lotteryOrganization, lotteryName, managerName, manager, resultDate, ticketPrice, players);
    }
}