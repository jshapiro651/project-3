// SPDX-License-Identifier: MIT
// Contract: 0x4299283381884A6f48d11039D23966759a762900
pragma solidity ^0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/interfaces/ISwapRouter.sol";

// Used to return any remaining balance of ETH from the swap
interface IUniswapRouter is ISwapRouter {
    function refundETH() external payable;
}

// We're using V3 of the Uniswap API
contract LimitOrderV3 {
    IUniswapRouter private constant uniswapRouter =
        IUniswapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address private constant FBP3T = 0x2a0B774554Ba949c8918185A9B5bf0A24DFB8284;
    address private constant WETH = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
    address payable private owner;
    uint256 public balance = 0;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "You do not have permission to execute this transaction"
        );
        _;
    }

    event BuyFromAcct(address indexed _from, uint256 _value);

    // This is our main function for executing a trade - it uses the WETH balance
    function buyFBP3TfromAccount(uint256 amountIn) external payable onlyOwner {
        // A contract that is spending it's own tokens needs to have a token approval (just like a wallet)
        // This automates that process
        ERC20(WETH).approve(address(uniswapRouter), amountIn);

        uint256 deadline = block.timestamp + 15;
        address tokenIn = WETH;
        address tokenOut = FBP3T;
        uint24 fee = 3000;
        address recipient = address(this);
        uint256 amountOutMinimum = 1;
        uint160 sqrtPriceLimitX96 = 0;

        emit BuyFromAcct(recipient, amountIn);

        // This creates a struct to represent the requested swap
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

        // Executes a swap
        // Documentation: https://docs.uniswap.org/protocol/guides/swaps/single-swaps
        // method{}() syntax ("special options") explained here:
        // https://docs.soliditylang.org/en/v0.8.11/control-structures.html?highlight=curly%20brackets#external-function-calls
        uniswapRouter.exactInputSingle{value: amountIn}(params);
        // Executes the refund of the remaining ETH back to our contract
        uniswapRouter.refundETH();
    }

    // This is a test function that uses the sender's wallet for the trade
    // If we were deploying to mainnet, we'd remove this...
    // Most of the functionality is the same as the previous method, so see the comments above
    // for details
    function convertExactEthToFBP3T() external payable {
        require(msg.value > 0, "Must include ETH in the request");

        uint256 deadline = block.timestamp + 15;
        address tokenIn = WETH;
        address tokenOut = FBP3T;
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

        // This sends the refundedETH back to the sender, rather than the contract
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(
            success,
            "Attempted to refund remaining ETH to sender, but failed"
        );
    }

    // Standard Withdraw/Deposit functionality

    function withdraw_eth(uint256 amount, address payable recipient) public {
        require(recipient == owner, "You do not own this account");
        balance = address(this).balance - amount;
        return recipient.transfer(amount);
    }

    function withdraw_fbp3t(uint256 amount, address payable recipient) public {
        require(recipient == owner, "You do not own this account");
        ERC20(FBP3T).transfer(recipient, amount);
    }

    function deposit() public payable {
        balance = address(this).balance;
    }

    receive() external payable {
        balance = address(this).balance;
    }
}
