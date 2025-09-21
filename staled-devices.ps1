# Krever Entra PowerShell (Connect-Entra) og Device.Read.All
Connect-Entra -Scopes 'Device.Read.All'

# Sett 180 dager som terskel
$dt = (Get-Date).AddDays(-180)

# Finn kandidater: ikke logget på siden terskeldato
$stale = Get-EntraDevice -All | Where-Object {
  $_.ApproximateLastSignInDateTime -le $dt
}

# Grovkontroller, evt. eksporter for review
$stale | Select-Object DisplayName, DeviceId, TrustType, 
  OperatingSystem, OperatingSystemVersion, ApproximateLastSignInDateTime |
  Export-Csv .\\StaleDevices-Review.csv -NoTypeInformation
