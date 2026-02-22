# Start Devnet
# This script starts the local Stacks devnet for development

try {
    clarinet devnet start
    Write-Host "Devnet started successfully."
} catch {
    Write-Host "Error starting devnet: $_"
    exit 1
}