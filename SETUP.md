# Development Environment Setup for Stacks Blockchain

This project uses Clarinet for Stacks dApp development.

## Prerequisites
- Node.js (version 16 or higher) installed
- npm (comes with Node.js)
- Clarinet CLI installed globally
- Docker installed (for local devnet)
- Git for version control

## Installation Steps
1. Install Node.js from https://nodejs.org/ (version 16 or higher)
2. Install Clarinet CLI globally using npm:
   ```
   npm install -g @hirosystems/clarinet-cli
   ```
3. Verify Clarinet installation:
   ```
   clarinet --version
   ```
4. Install Docker Desktop from https://www.docker.com/products/docker-desktop
5. Clone the repository (if not already done)

## Project Setup
1. Navigate to the project directory
2. Install project dependencies:
   ```
   npm install
   ```
3. Install Clarinet dependencies for the project:
   ```
   clarinet install
   ```

## Running Devnet
To start the local Stacks blockchain node for development:
```
clarinet devnet start
```

This will start a local devnet with Stacks node, Bitcoin node, and other services in Docker containers.

To stop the devnet:
```
clarinet devnet stop
```

## Testing Contracts
```
clarinet console
```