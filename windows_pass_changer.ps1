# Target: lapis (Windows Server 2016)
# Run as Administrator

$Users = @("Administrator", "steve", "alex", "enderman", "creeper", "villager", "zombie", "enderdragon", "irongolem", "chickenjockey", "ghast")
$OutputFile = "C:\windows_new_passwords.txt"

"CCDC Password Randomizer - lapis" | Out-File $OutputFile
"----------------------------------------" | Out-File $OutputFile -Append

# Load assembly for secure password generation
Add-Type -AssemblyName System.Web

foreach ($User in $Users) {
    # Check if user exists
    if (Get-LocalUser -Name $User -ErrorAction SilentlyContinue) {
        # Generate 16-char password with at least 4 non-alphanumeric characters
        $NewPass = [System.Web.Security.Membership]::GeneratePassword(16, 4)
        
        # Apply password securely
        $SecurePass = ConvertTo-SecureString $NewPass -AsPlainText -Force
        Set-LocalUser -Name $User -Password $SecurePass
        
        Write-Host "[+] Changed $User -> $NewPass" -ForegroundColor Green
        "$User : $NewPass" | Out-File $OutputFile -Append
    } else {
        Write-Host "[-] User $User does not exist on this box, skipping..." -ForegroundColor Yellow
    }
}

Write-Host "`nSUCCESS: All changed passwords saved to $OutputFile." -ForegroundColor Cyan
Write-Host "ACTION REQUIRED: Copy these to your local machine and submit your PCRs immediately!" -ForegroundColor Red