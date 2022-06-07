// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
// Token Contract: 0x2a0B774554Ba949c8918185A9B5bf0A24DFB8284
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
