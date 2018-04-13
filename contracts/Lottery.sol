pragma solidity ^0.4.17;

contract Lottery {
    address public manager;

    address[] public players;

    function Lottery() public {
        // don't have to do any declaration for msg variable- it's a global variable
        // have access to msg in anything that is within the contract, not just the constructor function
        manager = msg.sender;
    }
    // mark function as payable if someone is sending along some amount of ether
    function enter() public payable {
        // msg.value amount of ether in wei that is sent along
        require(msg.value > .01 ether);
        players.push(msg.sender);
    }

    // private- we don't want anyone else to call this function
    // view type not modifying state
    function random() private view returns (uint) {
        // block is a global variable access to at any time
        // uint()- takes hash and converts into unsigned number
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restricted {

        uint index = random() % players.length;

        // addresses has some functions tied to them like transfer
        // this is a reference to instance of current contract
        players[index].transfer(address(this).balance);

        // below creating a new dynamic array and making with initial size of zero
        players = new address[](0);

    }

    // modifier keyword adds function modifier
    // as a means to reduce the amount of code
    // need to add restricted to functions (add name to the function and then adds that code where underscore is)
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    // view not change data in project
    // returns array of addresses
    function getPlayers() public view returns(address[]) {
        return players;
    }

}
