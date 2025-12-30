# Load modified_global.ini into a hashtable (Key -> new value)
$replacements = @{}
Get-Content .\global_refactors.ini | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') {
        $key = $matches[1].Trim()
        $value = $matches[2]
        $replacements[$key] = $value
    }
}

# Process global.ini line by line and only replace values
Get-Content .\global.ini | ForEach-Object {
    if ($_ -match '^(.*?)(=)(.*)$') {
        $key = $matches[1].Trim()
        $prefix = $_.Substring(0, $_.IndexOf('=') + 1)  # Keep everything up to and including '=' (including spaces!)
        if ($replacements.ContainsKey($key)) {
            $prefix + $replacements[$key]
        } else {
            $_
        }
    } else {
        $_  # Empty lines / comments etc. remain unchanged
    }
} | Set-Content .\merged\global.ini -Encoding UTF8

# Automatically copy the merged file to StarCitizen installation
$sourcePath = ".\merged\global.ini"
$destinationPath = "..\..\StarCitizen\LIVE\data\Localization\english\global.ini"

# Copy the merged file to the destination
Copy-Item -Path $sourcePath -Destination $destinationPath -Force
Write-Host "Successfully created global.ini in merged directory" -ForegroundColor Green
Write-Host "Successfully copied to $destinationPath" -ForegroundColor Green
