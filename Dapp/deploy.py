from solcx import compile_standard

with open("./LimitOrder.sol", "r") as file:
    limit_order_file = file.read()

# Compile Our Solidity

compiled_sol = compile_standard(
   {
        "language": "Solidity",
        "sources": {"LimitOrder.sol": {"content": limit_order_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
                }
            }
        },
    },
    solc_version = "0.8.6", #pragma solidity ^0.8.6
)
print(compiled_sol)