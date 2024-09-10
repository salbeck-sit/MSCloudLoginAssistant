function Connect-MSCloudLoginAzure
{
    [CmdletBinding()]
    param()

    $WarningPreference = 'SilentlyContinue'
    $InformationPreference = 'SilentlyContinue'
    $ProgressPreference = 'SilentlyContinue'
    $VerbosePreference = 'SilentlyContinue'

    if ($Global:MSCloudLoginConnectionProfile.Azure.AuthenticationType -eq 'ServicePrincipalWithThumbprint')
    {
        Write-Verbose -Message "Attempting to connect to Azure using AAD App {$ApplicationID}"
        try
        {
            Write-Verbose -Message "Azure Connection Profile = $($Global:MSCloudLoginConnectionProfile.Azure | Out-String)"
            try
            {
                Clear-AzContext | Out-Null
                Connect-AzAccount -ApplicationId $Global:MSCloudLoginConnectionProfile.Azure.ApplicationId `
                                -TenantId $Global:MSCloudLoginConnectionProfile.Azure.TenantId `
                                -CertificateThumbprint $Global:MSCloudLoginConnectionProfile.Azure.CertificateThumbprint `
                                -Environment $Global:MSCloudLoginConnectionProfile.Azure.EnvironmentName | Out-Null
            }
            catch
            {
                Write-Verbose $_
            }
            $Global:MSCloudLoginConnectionProfile.Azure.ConnectedDateTime = [System.DateTime]::Now.ToString()
            $Global:MSCloudLoginConnectionProfile.Azure.Connected = $true
            $Global:MSCloudLoginConnectionProfile.Azure.MultiFactorAuthentication = $false
            Write-Verbose -Message "Successfully connected to Azure using AAD App {$ApplicationID}"
        }
        catch
        {
            throw $_
        }
    }
    else
    {
        throw "Specified authentication method is not supported."
    }
}
