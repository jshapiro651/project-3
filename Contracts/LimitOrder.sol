pragma solidity ^0.5.0;

contract LimitOrder {
    address payable accountOwner = 0x2fEb1512183545f48f6b9C5b4EbfCaF49CfCa6F3;

    // function withdraw(uint amount, address payable recipient) public {
    //     require(recipient == accountOwner, "You don’t own this account!");
    //     return recipient.transfer(amount);
    // }

    function deposit() public payable {}

    function() external payable {}
}
