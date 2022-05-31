// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

//import the ERC20 interface
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

interface IUniswapV2Pair {
    function token0() external view returns (address);

    function token1() external view returns (address);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
}

interface IUniswapV2Factory {
    function getPair(address token0, address token1) external returns (address);
}

///////////////////////////////////////////////////////////////////////////////

contract LimitOrder {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address private constant WETH = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;

    address payable accountOwner =
        payable(0x2CEa0274e15517ace17044FC513e30750f6Cc177);

    uint256 public balance = 0;

    function swapExactETHforTokens(
        address tokenOut,
        uint256 amountOut,
        uint256 deadline
    ) external payable {
        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = tokenOut;

        IUniswapV2Router02(UNISWAP_V2_ROUTER).swapExactETHForTokens{
            value: msg.value
        }(amountOut, path, msg.sender, deadline);
    }

    function withdraw(uint256 amount, address payable recipient) public {
        //require(recipient == accountOwner, "You don’t own this account!");
        balance = address(this).balance - amount;
        return recipient.transfer(amount);
    }

    function deposit() public payable {
        balance = address(this).balance;
    }

    fallback() external payable {}
}
