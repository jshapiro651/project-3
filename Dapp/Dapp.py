from email.headerregistry import Address
import os
import json
from web3 import Web3
from eth_account import Account
from eth_account.signers.local import LocalAccount
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
import webbrowser

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
    with open(Path('./LimitOrder_ABI.json')) as f:
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

# https://web3py.readthedocs.io/en/latest/web3.eth.account.html#read-a-private-key-from-an-environment-variable
private_key = os.getenv("PRIVATE_KEY")
assert private_key is not None, "You must set PRIVATE_KEY environment variable"
assert private_key.startswith(
    "0x"), "Private key must start with 0x hex prefix"

account: LocalAccount = Account.from_key(private_key)
# w3.middleware_onion.add(construct_sign_and_send_raw_middleware(account))

st.markdown("# Uniswap Limit Order Project (Phase One)")
st.markdown("## Welcome to our dApp!")
st.text(" \n")

st.sidebar.markdown(
    "## What can we do for you today?")

# Check Balance button

balance = contract.functions.balance().call()
if st.sidebar.button("Check Balance"):
    st.sidebar.write(f"The current balance is {balance}")

# ETH Withdraw button
eth_amount = st.sidebar.number_input("Input amount of ETH to withdraw")
eth_amount = w3.toWei(eth_amount, 'ether')
# Create a button that calls the `send_transaction` function and returns the transaction hash
if st.sidebar.button("Withdraw ETH"):
    nonce = w3.eth.get_transaction_count(pub_account)
    w_txn = contract.functions.withdraw_eth(eth_amount, pub_account).buildTransaction({
        'chainId': 42,
        'gas': 3000000,
        'maxFeePerGas': w3.toWei('10', 'gwei'),
        'maxPriorityFeePerGas': w3.toWei('10', 'gwei'),
        'nonce': nonce,
    })

    signed_txn = account.signTransaction(w_txn)
    tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

    with st.spinner(text='Transaction in progress...'):
        receipt = w3.eth.waitForTransactionReceipt(tx_hash)
        st.success(f'Transaction successful! Enjoy your ETH! | {dict(receipt)}')
        st.balloons()

# FBP3T Withdraw button
fbp3t_amount = st.sidebar.number_input("Input amount of FBP3T to withdraw")
fbp3t_amount = w3.toWei(fbp3t_amount, 'ether')
# Create a button that calls the `send_transaction` function and returns the transaction hash
if st.sidebar.button("Withdraw FBP3T"):
    nonce = w3.eth.get_transaction_count(pub_account)
    w_txn = contract.functions.withdraw_fbp3t(fbp3t_amount, pub_account).buildTransaction({
        'chainId': 42,
        'gas': 3000000,
        'maxFeePerGas': w3.toWei('10', 'gwei'),
        'maxPriorityFeePerGas': w3.toWei('10', 'gwei'),
        'nonce': nonce,
    })

    signed_txn = account.signTransaction(w_txn)
    tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

    with st.spinner(text='Transaction in progress...'):
        receipt = w3.eth.waitForTransactionReceipt(tx_hash)
        st.success(f'Transaction successful! Enjoy your FBP3T! | {dict(receipt)}')
        st.balloons()

# Swap button
swap_amount = st.sidebar.number_input(
    "Input the amount of ETH you'd like to swap for FBP3T")
swap_amount = w3.toWei(swap_amount, 'ether')
if st.sidebar.button("Swap ETH for FBP3T"):
    nonce = w3.eth.get_transaction_count(pub_account)
    txn = contract.functions.buyFBP3TfromAccount(swap_amount).buildTransaction({
        'chainId': 42,
        'gas': 3000000,
        'maxFeePerGas': w3.toWei('10', 'gwei'),
        'maxPriorityFeePerGas': w3.toWei('10', 'gwei'),
        'nonce': nonce,
    })
    signed_txn = account.signTransaction(txn)
    tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

    with st.spinner(text='Transaction in progress...'):
        receipt = w3.eth.waitForTransactionReceipt(tx_hash)
        st.success(f'Swap successful! Enjoy your FBP3T! | {dict(receipt)}')
        st.balloons()

# Transaction Validation
url = f"https://kovan.etherscan.io/address/{contract_address}"
st.sidebar.markdown('## Validate your transaction')
if st.sidebar.button('Open Etherscan'):
    webbrowser.open_new_tab(url)

# Main page image

st.image('../Images/fbp3t.png')