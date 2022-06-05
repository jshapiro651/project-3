# University of Minnesota: Fintech Boot Camp: Project 3

## Participants

- [Jason Shapiro](https://www.linkedin.com/in/jshapiro/)
- Jon Kearney
- Tim Wardlow

## Project Synopsis

This is the first phase of a larger project (create limit order functionality on Uniswap).

### Primary Goals

- Create a Solidity contract that is able to interact with the Uniswap V3 API
- Create a W3 enabled page that is able to act as the Dapp’s trigger for the Smart Contract methods

### Secondary Goals

- Work with some new services
  - Evaluate Remix Alternatives (Truffle, Hard Hat)
  - Evaluate Test Net alternatives (Kovan Test Network, Ganache-CLI, Alchemy)
- Collect some post-project “research questions” related to the larger scope of this project (given that we’re only finishing “phase one” of the total application).

### Our Final Tech Stack

- Solidity (language)
- Remix (IDE)
- Uniswap V3 (Solidity API)
- MetaMask (wallet)
- Infura (node)
- Kovan Test Network (blockchain)
- Streamlit (UI)
- Web3 & Eth_Account (Python APIs)

### Other Tech Stacks We Investigated

- Visual Studio Code (IDE) (w/ Truffle Extension)
- Alchemy (node that forks Ethereum’s Mainnet)
- Ganache-CLI (blockchain server that proxies Alchemy)
- Truffle (compiler/deployer)
- Hard Hat (compiler/deployer)

## Project Structure

- [Contracts](Contracts/) | Final version of our contracts
- [Contract Deployment](CONTRACT_DEPLOYMENT.md) | Instructions on how these contracts were deployed
- [Dapp Souce Code](Dapp/) | Streamlit UI & ABI files
- [Images](Images/) | Images used in our documentation
- [Experimental](Experimental/) | Various experiments we made that led us to our final implementation; consider this "not ready for prime time" code that we want to return to, in the near future

## Schedule

- **05/21 (Sat)**
  - Project Management Discussion
  - POC: Install Uniswap Test Stack and Run Through Demo
- **05/23 (Mon)**
  - Update/Complete Project Synopsis
  - Diagrams for Dapp Flow
  - Divide Up Work
  - Solidity Coding w/ Uniswap Stack
- **05/25 (Wed)**
  - Solidity Coding w/ Uniswap Stack
- **06/01 (Wed)**
  - Solidity Coding w/ Uniswap Stack
- **06/04 (Sat)**
  - Research Questions
- **06/06 (Mon)**
  - Finish Presentation Materials
- **06/08 (Wed)**
  - Project Presentation

## Post-Project Research Questions

- How do we execute a swap on behalf of a user? Will that info be stored in the Dapp or in the Contract?
- Is there a way to use the customer's account to pay gas fees when initiating the trade (vs. the "sender/dapp")?
- How do we make this completely trustless?
- Why doesn't the withdraw show the amount withdrawn in the transaction (MetaMask)?

## Resources

- [Kovan ETH/LINK faucet](https://faucets.chain.link/)
- [Truffle Suite Documentation](https://trufflesuite.com/docs/truffle/quickstart/)
- [Truffle Suite VS Code Extension](https://trufflesuite.com/blog/build-on-web3-with-truffle-vs-code-extension/)
- [Uniswap Tutorial](https://docs.uniswap.org/protocol/V2/guides/smart-contract-integration/quick-start)
- [Ethereum Unit Converter](https://eth-converter.com/)
