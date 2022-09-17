// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Lottery {
    address public owner; // Owner;
    address payable[] private allPlayers; // dynamic array with all player's address which is payable;
    uint lotteryNo; // keep track of lotteries like how much lottries are done;

    mapping (uint => address payable) public winners;

    constructor() {
        // adding the address of owner
        owner = msg.sender;
        lotteryNo = 1;
    }

    // get balance
    function get_balance() public view returns (uint256) {
        return address(this).balance;
    }

    // Get all players
    function get_players() public view returns (address payable[] memory) {
        return allPlayers;
    }

    // get lottery winners by lottery ID.
    function get_winners(uint _lotteryId) public view returns (address payable) {
        return winners[_lotteryId];
    }

    // Enter the lottery
    function addLottery() public payable {
        // require a lottery balance before executing below lines.
        require(msg.value > 0.1 ether, "Can't add lottery for free");

        // If ethers are there then add the address.
        allPlayers.push(payable(msg.sender));
    }

    // Get random number by using keccak256 algorithm ( Not a stable thing to do)
    function randomNumber() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    // getting winner using random number
    function winner() public onlyOwner {
        // Check if there is an open lottery 
        require(allPlayers.length > 0, "No lottery currently open");

        uint256 index = randomNumber() % allPlayers.length;
        allPlayers[index].transfer(address(this).balance);
        winners[lotteryNo] = allPlayers[index];
        lotteryNo++;
           
        // clear the players
        delete allPlayers;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}