# Input password
$password = "MySecretPassword"

# Convert to bytes
$bytes = [System.Text.Encoding]::UTF8.GetBytes($password)

# Create SHA256 object
$sha256 = [System.Security.Cryptography.SHA256]::Create()

# Compute hash
$hashBytes = $sha256.ComputeHash($bytes)

# Convert to hex string
$hashString = -join ($hashBytes | ForEach-Object { $_.ToString("x2") })

Write-Output $hashString
