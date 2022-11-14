// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Lottery {
    address public owner; // Owner;
    address[] public allPlayers; // dynamic array with all player's address;
    uint256 public lotteryNo; // keep track of lotteries like how much lottries are done;

    mapping (uint256 => address) public winners;

    constructor() {
        // adding the address of owner
        owner = msg.sender;
        lotteryNo = 1;
    }

    /// @dev get balance
    function get_balance() public view returns (uint256) {
        return address(this).balance;
    }

    /// @dev Get all players
    function get_players() public view returns (address[] memory) {
        return allPlayers;
    }

    /// @dev get lottery winners by lottery ID.
    function get_winners(uint _lotteryId) public view returns (address) {
        return winners[_lotteryId];
    }

    /// @dev Enter the lottery
    function addLottery() public payable {
        // require a lottery balance before executing below lines.
        require(msg.value > 0.1 ether, "not enough deposit");

        // If ethers are there then add the address.
        allPlayers.push(msg.sender);
    }

    /// @dev Get random number by using keccak256 algorithm ( Not a stable thing to do)
    function randomNumber() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    /// @dev getting winner using random number
    function winner() public onlyOwner {
        uint256 index = randomNumber() % allPlayers.length;
        address winner = allPlayers[index];
        winners[lotteryNo] = winner;
        lotteryNo++;
           
        // clear the players
        delete allPlayers;

        // prevent reentrancy attacks
        (bool success, ) = payable(winner).call{ value: address(this).balance }("");
        require(success, "failed to transfer");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }
}