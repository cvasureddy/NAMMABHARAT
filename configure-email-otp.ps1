# Configure SMTP credentials without writing them into the project.
# Gmail users should create an App Password after enabling 2-Step Verification.
$ErrorActionPreference = 'Stop'

$mailHost = Read-Host 'SMTP host (Gmail: smtp.gmail.com)'
if ([string]::IsNullOrWhiteSpace($mailHost)) { $mailHost = 'smtp.gmail.com' }

$mailPortText = Read-Host 'SMTP port (usually 587)'
if ([string]::IsNullOrWhiteSpace($mailPortText)) { $mailPortText = '587' }
$mailPort = 0
if (-not [int]::TryParse($mailPortText, [ref]$mailPort) -or $mailPort -lt 1 -or $mailPort -gt 65535) {
    throw 'Invalid SMTP port.'
}

$mailUser = Read-Host 'SMTP sender email address'
if ([string]::IsNullOrWhiteSpace($mailUser)) { throw 'Email address is required.' }

$securePassword = Read-Host 'SMTP password / Gmail App Password (input is hidden)' -AsSecureString
$pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
try {
    $mailPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
    $mailPassword = $mailPassword -replace '\s', ''
    if ([string]::IsNullOrWhiteSpace($mailPassword)) { throw 'SMTP password is required.' }

    [Environment]::SetEnvironmentVariable('MAIL_HOST', $mailHost, 'User')
    [Environment]::SetEnvironmentVariable('MAIL_PORT', [string]$mailPort, 'User')
    [Environment]::SetEnvironmentVariable('MAIL_USERNAME', $mailUser, 'User')
    [Environment]::SetEnvironmentVariable('MAIL_PASSWORD', $mailPassword, 'User')
}
finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
    $mailPassword = $null
}

# Keep an existing OTP pepper stable so codes already sent remain verifiable.
$pepper = [Environment]::GetEnvironmentVariable('OTP_PEPPER', 'User')
if ([string]::IsNullOrWhiteSpace($pepper)) {
    $bytes = New-Object byte[] 48
    $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $rng.GetBytes($bytes)
    }
    finally {
        $rng.Dispose()
    }
    $pepper = [Convert]::ToBase64String($bytes)
    [Environment]::SetEnvironmentVariable('OTP_PEPPER', $pepper, 'User')
}

Write-Host ''
Write-Host 'SMTP settings saved to your Windows user environment.'
Write-Host 'The SMTP password was not written into this project.'
Write-Host 'Restart IntelliJ IDEA / terminals so the new variables are loaded.'
Write-Host 'Then run the Namma Bhavishy backend and test citizen registration.'
