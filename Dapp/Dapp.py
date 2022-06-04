import os
import json
from web3 import Web3
from eth_account import Account
from eth_account.signers.local import LocalAccount
from web3.middleware import construct_sign_and_send_raw_middleware
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st

load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

# Set the contract address (this is the address of the deployed contract)
contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

# Set the public account
pub_account = os.getenv("ACCOUNT")

# Cache the contract on load


@st.cache(allow_output_mutation=True)
# Define the load_contract function
def load_contract():

    # Load Limit Order ABI
    with open(Path('./limit_order_abi.json')) as f:
        contract_abi = json.load(f)

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=contract_abi
    )
    # Return the contract from the function
    return contract


# Load the contract
contract = load_contract()

# Display balance
balance = contract.functions.balance().call()
st.write(f"The balance is {balance}")

# https://web3py.readthedocs.io/en/latest/web3.eth.account.html#read-a-private-key-from-an-environment-variable
private_key = os.getenv("PRIVATE_KEY")
assert private_key is not None, "You must set PRIVATE_KEY environment variable"
assert private_key.startswith(
    "0x"), "Private key must start with 0x hex prefix"

account: LocalAccount = Account.from_key(private_key)
# w3.middleware_onion.add(construct_sign_and_send_raw_middleware(account))

if st.button("Swap ETH for FBP3T"):
    nonce = w3.eth.get_transaction_count(pub_account)
    txn = contract.functions.buyFBP3TfromAccount(156520000000000).buildTransaction({
        'chainId': 42,
        'gas': 3000000,
        'maxFeePerGas': w3.toWei('10', 'gwei'),
        'maxPriorityFeePerGas': w3.toWei('10', 'gwei'),
        'nonce': nonce,
    })
    signed_txn = account.signTransaction(txn)
    w3.eth.send_raw_transaction(signed_txn.rawTransaction)

# This doesn't work...
# if st.button("Swap ETH for FBP3T"):
#     contract.functions.buyFBP3TfromAccount(
#         156520000000000).transact({'gas': 1000000})