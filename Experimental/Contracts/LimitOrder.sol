// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

//import the ERC20 interface
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

contract LimitOrder {
    address internal constant UNISWAP_ROUTER_ADDRESS =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapV2Router02 public uniswapRouter;
    address private myToken = 0x74B656031DfBD104dAdFB9ac0A2A620A4170b9e7;

    uint256 public balance = 0;

    constructor() {
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
    }

    function swapExactETHforTokens(uint256 amountOut) external payable {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = myToken;

        uniswapRouter.swapExactETHForTokens{value: msg.value}(
            amountOut,
            path,
            msg.sender,
            block.timestamp + 15
        );
    }

    function withdraw(uint256 amount, address payable recipient) public {
        //require(recipient == accountOwner, "You don’t own this account!");
        balance = address(this).balance - amount;
        return recipient.transfer(amount);
    }

    function deposit() public payable {
        balance = address(this).balance;
    }

    fallback() external payable {
        balance = address(this).balance;
    }
}
