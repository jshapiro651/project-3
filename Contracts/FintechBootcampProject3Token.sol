// SPDX-License-Identifier: MIT
// Kovan Token Contract: 0x74B656031DfBD104dAdFB9ac0A2A620A4170b9e7
pragma solidity ^0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC20/ERC20.sol";

contract FintechBootcampToken is ERC20 {
    address payable owner;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "You do not have permission to mint these tokens!"
        );
        _;
    }

    constructor(uint256 initial_supply)
        ERC20("Fintech Bootcamp Proj 3 Token", "FBP3T")
    {
        owner = payable(msg.sender);
        _mint(owner, initial_supply);
    }

    function mint(address recipient, uint256 amount) public onlyOwner {
        _mint(recipient, amount);
    }
}
