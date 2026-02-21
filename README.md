# Sustainable Supply Chain Tracker

A decentralized platform for transparent and verifiable sustainable supply chains, leveraging the Stacks blockchain to track product lifecycles from source to consumer. Empowering eco-conscious consumers and ethical suppliers through NFTs, DAOs, and Clarity smart contracts deployed on Stacks mainnet.

## Setup

See [SETUP.md](SETUP.md) for development environment setup.

## Features

- **Supplier Onboarding & Verification**: Secure registration with oracle-backed credential checks and community voting.
- **NFT Sustainability Passports**: Unique digital certificates for products, embedding supply chain data like carbon footprint and labor conditions.
- **Consumer Marketplace**: Browse and purchase verified sustainable products with full traceability.
- **DAO Governance**: Token holders vote on standards, fund audits, and approve suppliers.
- **DeFi Integration**: Stake tokens for rewards, trade carbon credits, and access yield farming.

## Problem Solved

Traditional supply chains lack transparency, enabling greenwashing and unethical practices. This Web3 platform ensures every product's journey is immutable and verifiable, building trust in sustainable markets.

## Tech Stack

- **Frontend**: Next.js with @stacks/connect for Web3 integration
- **Blockchain**: Stacks mainnet with Clarity smart contracts (Clarinet for development)
- **Storage**: IPFS/Arweave for off-chain data
- **Oracles**: Chainlink or custom oracles for real-world data verification
- **Wallets**: Hiro Wallet, Xverse
- **Other**: Stacks.js for contract interactions, The Graph for indexing

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/victor-olamide/Supplier-Onboarding-Verification.git
   cd sustainable-supply-chain-tracker
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Set up Clarinet and deploy contracts:
   ```
   clarinet install
   clarinet contracts
   clarinet test
   clarinet deployments generate --devnet
   clarinet deployments apply --mainnet
   ```

4. Configure environment variables (e.g., Stacks API key, IPFS gateway).

5. Run the development server:
   ```
   npm run dev
   ```

## Usage

- **For Suppliers**: Register via wallet, submit verification docs, and mint product NFTs.
- **For Consumers**: Connect wallet, browse marketplace, view supply chain data, and purchase.
- **For Governance**: Stake tokens to vote on proposals and earn rewards.

## Smart Contracts (Clarity)

- `supplier-registry.clar`: Manages supplier onboarding and verification.
- `product-nft.clar`: SIP-009 compliant NFT for sustainability passports.
- `dao-governance.clar`: Handles voting and proposals.

## Contributing

1. Fork the repo and create a feature branch.
2. Submit DAO proposals for major changes.
3. Follow Clarity best practices and test thoroughly.

## Roadmap

- Phase 1: Core onboarding and NFT minting.
- Phase 2: Marketplace and DeFi features.
- Phase 3: Multi-chain support and mobile app.

## License

MIT License - see LICENSE file for details.

## Contact

For questions or partnerships, reach out via [email/discord].