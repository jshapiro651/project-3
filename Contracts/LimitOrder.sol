// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/interfaces/ISwapRouter.sol";

interface IUniswapRouter is ISwapRouter {
    function refundETH() external payable;
}

contract LimitOrderV3 {
    IUniswapRouter private constant uniswapRouter =
        IUniswapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address private constant fintechBootcampProj3Token =
        0x74B656031DfBD104dAdFB9ac0A2A620A4170b9e7;
    address private constant WETH9 = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
    address payable owner;
    uint256 public balance = 0;

    constructor() {
        owner = payable(msg.sender);
    }

    function buyFBP3TfromAccount(uint256 amountIn) external {
        uint256 deadline = block.timestamp + 15;
        address tokenIn = WETH9;
        address tokenOut = fintechBootcampProj3Token;
        uint24 fee = 3000;
        address recipient = address(this);
        uint256 amountOutMinimum = 1;
        uint160 sqrtPriceLimitX96 = 0;

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams(
                tokenIn,
                tokenOut,
                fee,
                recipient,
                deadline,
                amountIn,
                amountOutMinimum,
                sqrtPriceLimitX96
            );

        uniswapRouter.exactInputSingle(params);
        uniswapRouter.refundETH();

        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(
            success,
            "Attempted to refund remaining ETH to sender, but failed"
        );
    }

    function convertExactEthToFBP3T() external payable {
        require(msg.value > 0, "Must include ETH in the request");

        uint256 deadline = block.timestamp + 15;
        address tokenIn = WETH9;
        address tokenOut = fintechBootcampProj3Token;
        uint24 fee = 3000;
        address recipient = msg.sender;
        uint256 amountIn = msg.value;
        uint256 amountOutMinimum = 1;
        uint160 sqrtPriceLimitX96 = 0;

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams(
                tokenIn,
                tokenOut,
                fee,
                recipient,
                deadline,
                amountIn,
                amountOutMinimum,
                sqrtPriceLimitX96
            );

        uniswapRouter.exactInputSingle{value: msg.value}(params);
        uniswapRouter.refundETH();

        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(
            success,
            "Attempted to refund remaining ETH to sender, but failed"
        );
    }

    function withdraw(uint256 amount, address payable recipient) public {
        require(recipient == owner, "You do not own this account");
        balance = address(this).balance - amount;
        return recipient.transfer(amount);
    }

    function deposit() public payable {
        balance = address(this).balance;
    }

    receive() external payable {
        balance = address(this).balance;
    }
}
