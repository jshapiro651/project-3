import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st

load_dotenv()  ## import env variables in .env files 

# Define and connect a new Web3 provider. Copied URL from remix. Might need to just copy from the compiler if this does not work
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))   ## connection to Remix

################################################################################
# Contract Helper function:
# 1. Loads the contract once using cache
# 2. Connects to the contract using the contract address and ABI
################################################################################

# Cache the contract on load
@st.cache(allow_output_mutation=True)     ## cache the smart contract in the memory of the physical device running the frontend  
# Define the load_contract function
def load_contract():

    # Load Art Gallery ABIC:\Users\jonat\project-3\Dapp\compiled_LimitOrder.json
    with open(Path('compiled_LimitOrder.json')) as f:   ## defining the path to the backend
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

# Streamlit Title
st.markdown('Limit Order Project')
################################################################################
# Award Certificate
################################################################################

#accounts = w3.eth.accounts  ## gettting all the accounts from ganache 
#account = accounts[0]       ## by default display the 1st account 
#student_account = st.selectbox("Select Account", options=accounts)
#certificate_details = st.text_input("Certificate Details", value="FinTech Certificate of Completion")
#if st.button("Award Certificate"):
#    contract.functions.awardCertificate(student_account, certificate_details).transact({'from': account, 'gas': 1000000})

################################################################################
# Display Certificate
################################################################################
#certificate_id = st.number_input("Enter a Certificate Token ID to display", value=0, step=1)
#if st.button("Display Certificate"):
    # Get the certificate owner
#    certificate_owner = contract.functions.ownerOf(certificate_id).call()
#    st.write(f"The certificate was awarded to {certificate_owner}")

    # Get the certificate's metadata
#    certificate_uri = contract.functions.tokenURI(certificate_id).call()
 #   st.write(f"The certificate's tokenURI metadata is {certificate_uri}")
