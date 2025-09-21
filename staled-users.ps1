# Install-Module Microsoft.Graph -Scope CurrentUser
Import-Module Microsoft.Graph

# Minste nødvendige scopes for sign-in activity:
Connect-MgGraph -Scopes "User.Read.All","AuditLog.Read.All"

$days = 180
$cutoff = (Get-Date).AddDays(-$days)

# Hent brukere med sign-in activity (inkl. lastSuccessfulSignInDateTime)
$users = Get-MgUser -All -Property "id,displayName,userType,accountEnabled,signInActivity"

$stale = $users | Where-Object {
  # Merk: signInActivity kan være tom for aldri‑innloggede kontoer
  -not $_.signInActivity -or
  ([datetime]$_.signInActivity.lastSuccessfulSignInDateTime -lt $cutoff)
}

$stale | Select-Object displayName, userType, accountEnabled,
  @{n="lastSuccessfulSignIn";e={$_.signInActivity.lastSuccessfulSignInDateTime}} |
  Export-Csv .\StaleUsers-Report.csv -NoTypeInformation