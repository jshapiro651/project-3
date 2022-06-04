import os
import json
from web3 import Web3
from eth_account import Account
from eth_account.signers.local import LocalAccount
from web3.middleware import construct_sign_and_send_raw_middleware
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st

load_dotenv()  ## import env variables in .env files 

# Define and connect a new Web3 provider. Copied URL from remix. Might need to just copy from the compiler if this does not work
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))   ## connection to Infura

# Set the contract address to the address of the deployed contract from Remix
contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

# Set the public account
pub_account = os.getenv("ACCOUNT")

# Cache the contract on load
@st.cache(allow_output_mutation=True)     ## cache the smart contract in the memory of the physical device running the frontend  
# Define the load_contract function
def load_contract():

    # ABIC:\Users\jonat\project-3\Dapp\compiled_LimitOrder.json
    with open(Path('./limit_order_abi.json')) as f:   ## defining the path to the backend
        compiled_LimitOrder = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")  ## address of the smart contract (backend)

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=compiled_LimitOrder
    )
    # Return the contract from the function
    return contract


# Load the contract
contract = load_contract()   ## loading contract and calling 'contract' 


# https://web3py.readthedocs.io/en/latest/web3.eth.account.html#read-a-private-key-from-an-environment-variable
private_key = os.getenv("PRIVATE_KEY")
assert private_key is not None, "You must set PRIVATE_KEY environment variable"
assert private_key.startswith(
    "0x"), "Private key must start with 0x hex prefix"

account: LocalAccount = Account.from_key(private_key)
# w3.middleware_onion.add(construct_sign_and_send_raw_middleware(account))

# Streamlit Title
st.markdown("# Limit Order Project")
st.text("\n")

st.sidebar.markdown("## Interact with the Contract")


# Display balance
balance = contract.functions.balance().call()
st.write(f"The balance is {balance} WEI")

# Check Balance button on the sidebar
if st.sidebar.button("Check Balance (WEI)"):
    st.write(f"The balance is {balance} WEI")

swap_amount = st.sidebar.number_input("Input the amount of ETH you would like to swap.")

#Swap ETH for FBP3T button on the sidebar
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
    w3.eth.send_raw_transaction(signed_txn.rawTransaction)



# This doesn't work...
# if st.button("Swap ETH for FBP3T"):
#     contract.functions.buyFBP3TfromAccount(
#         156520000000000).transact({'gas': 1000000})

#amount = st.sidebar.number_input("Amount to Withdraw")
#payable_recipient = "0x74B656031DfBD104dAdFB9ac0A2A620A4170b9e7"
# Withdraw button on the sidebar
#if st.sidebar.button("Withdraw"):
    #amount = st.sidebar.number_input("Amount to Withdraw")
    #recipient = st.sidebar.text_input("Input Recipeint's Address")
    #nonce = w3.eth.get_transaction_count(pub_account)
    #w_txn = contract.functions.withdraw(amount, payable_recipient).buildTransaction({
        #'chainId': 42,
        #'gas': 3000000,
        #'maxFeePerGas': w3.toWei('10', 'gwei'),
        #'maxPriorityFeePerGas': w3.toWei('10', 'gwei'),
        #'nonce': nonce,
    #})
    #w_signed_txn = account.signTransaction(w_txn)
    #w3.eth.send_raw_transaction(w_signed_txn.rawTransaction)
        

# $ streamlit run https://raw.githubusercontent.com/streamlit/demo-uber-nyc-pickups/master/streamlit_app.py
# How to pass a URL to streamlit