pragma solidity ^0.5.0;

contract LimitOrder {
    address payable accountOwner = 0x98D32dB5496840979e7460dA7F4808Dc9979d39c;

    uint256 public balance = 0;

    function withdraw(uint256 amount, address payable recipient) public {
        require(recipient == accountOwner, "You don’t own this account!");
        balance = address(this).balance - amount;
        // return recipient.transfer(amount);
        return msg.sender.transfer(amount);
    }

    function deposit() public payable {
        balance = address(this).balance;
    }
}
