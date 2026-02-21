# Development Environment Setup for Stacks Blockchain

This project uses Clarinet for Stacks dApp development.

## Prerequisites
- Node.js (version 16 or higher) installed
- npm (comes with Node.js)
- Clarinet CLI installed globally
- Docker installed (for local devnet)
- Git for version control

## Installation Steps
1. Install Node.js from https://nodejs.org/
2. Download Clarinet from https://github.com/stx-labs/clarinet/releases
3. Extract to a directory and add to PATH
4. Install Docker Desktop from https://www.docker.com/products/docker-desktop

## Running Devnet
To start local Stacks node:
```
clarinet devnet start
```

## Testing Contracts
```
clarinet console
```