// SPDX-License-Identifier: MIT
// Contract: 0x44bde79162D767DA1f12eC8F5C16934Ed48f1402
pragma solidity ^0.8.6;

import "https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/interfaces/ISwapRouter.sol";
import "https://github.com/Uniswap/v3-periphery/blob/9ca9575d09b0b8d985cc4d9a0f689f7a4470ecb7/contracts/libraries/TransferHelper.sol";

interface IUniswapRouter is ISwapRouter {
    function refundETH() external payable;
}

contract LimitOrderV3 {
    IUniswapRouter private constant uniswapRouter =
        IUniswapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address private constant FBP3T = 0x74B656031DfBD104dAdFB9ac0A2A620A4170b9e7;
    address private constant WETH9 = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
    address payable private owner;
    uint256 public balance = 0;

    constructor() {
        owner = payable(msg.sender);
    }

    event BuyFromAcct(address indexed _from, uint256 _value);

    function buyFBP3TfromAccount(uint256 amountIn) external payable {
        TransferHelper.safeApprove(WETH9, address(uniswapRouter), amountIn);

        uint256 deadline = block.timestamp + 15;
        address tokenIn = WETH9;
        address tokenOut = FBP3T;
        uint24 fee = 3000;
        address recipient = address(this);
        uint256 amountOutMinimum = 1;
        uint160 sqrtPriceLimitX96 = 0;

        emit BuyFromAcct(recipient, amountIn);

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

        uniswapRouter.exactInputSingle{value: amountIn}(params);
        uniswapRouter.refundETH();
    }

    function convertExactEthToFBP3T() external payable {
        require(msg.value > 0, "Must include ETH in the request");

        uint256 deadline = block.timestamp + 15;
        address tokenIn = WETH9;
        address tokenOut = FBP3T;
        uint24 fee = 3000;
        address recipient = msg.sender;
        uint256 amountIn = msg.value;
        uint256 amountOutMinimum = 1;
        uint160 sqrtPriceLimitX96 = 0;
        // Documentation: https://docs.uniswap.org/protocol/guides/swaps/single-swaps
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

        // method{}() syntax explained here:
        // https://docs.soliditylang.org/en/v0.8.11/control-structures.html?highlight=curly%20brackets#external-function-calls
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
