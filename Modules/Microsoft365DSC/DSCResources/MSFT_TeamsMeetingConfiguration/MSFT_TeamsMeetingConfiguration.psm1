function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

        [Parameter()]
        [System.String]
        $LogoURL,

        [Parameter()]
        [System.String]
        $LegalURL,

        [Parameter()]
        [System.String]
        $HelpURL,

        [Parameter()]
        [System.String]
        $CustomFooterText,

        [Parameter()]
        [System.Boolean]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.Boolean]
        $EnableQoS,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAudioPort = 50000,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientVideoPort = 50020,

        [Parameter()]
        [System.UInt32]
        $ClientVideoPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAppSharingPort = 50040,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPortRange = 20,

        [Parameter()]
        [System.Boolean]
        $ClientMediaPortRangeEnabled,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Getting configuration of Teams Meeting"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $config = Get-CsTeamsMeetingConfiguration -ErrorAction Stop

        return @{
            Identity                    = $Identity
            LogoURL                     = $config.LogoURL
            LegalURL                    = $config.LegalURL
            HelpURL                     = $config.HelpURL
            CustomFooterText            = $config.CustomFooterText
            DisableAnonymousJoin        = $config.DisableAnonymousJoin
            EnableQoS                   = $config.EnableQoS
            ClientAudioPort             = $config.ClientAudioPort
            ClientAudioPortRange        = $config.ClientAudioPortRange
            ClientVideoPort             = $config.ClientVideoPort
            ClientVideoPortRange        = $config.ClientVideoPortRange
            ClientAppSharingPort        = $config.ClientAppSharingPort
            ClientAppSharingPortRange   = $config.ClientAppSharingPortRange
            ClientMediaPortRangeEnabled = $config.ClientMediaPortRangeEnabled
            Credential          = $Credential
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        throw $_
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

        [Parameter()]
        [System.String]
        $LogoURL,

        [Parameter()]
        [System.String]
        $LegalURL,

        [Parameter()]
        [System.String]
        $HelpURL,

        [Parameter()]
        [System.String]
        $CustomFooterText,

        [Parameter()]
        [System.Boolean]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.Boolean]
        $EnableQoS,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAudioPort = 50000,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientVideoPort = 50020,

        [Parameter()]
        [System.UInt32]
        $ClientVideoPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAppSharingPort = 50040,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPortRange = 20,

        [Parameter()]
        [System.Boolean]
        $ClientMediaPortRangeEnabled,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting configuration of Teams Meetings"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $SetParams = $PSBoundParameters
    $SetParams.Remove("Credential")

    Set-CsTeamsMeetingConfiguration @SetParams
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Global')]
        $Identity,

        [Parameter()]
        [System.String]
        $LogoURL,

        [Parameter()]
        [System.String]
        $LegalURL,

        [Parameter()]
        [System.String]
        $HelpURL,

        [Parameter()]
        [System.String]
        $CustomFooterText,

        [Parameter()]
        [System.Boolean]
        $DisableAnonymousJoin,

        [Parameter()]
        [System.Boolean]
        $EnableQoS,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAudioPort = 50000,

        [Parameter()]
        [System.UInt32]
        $ClientAudioPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientVideoPort = 50020,

        [Parameter()]
        [System.UInt32]
        $ClientVideoPortRange = 20,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(1024, 65535)]
        $ClientAppSharingPort = 50040,

        [Parameter()]
        [System.UInt32]
        $ClientAppSharingPortRange = 20,

        [Parameter()]
        [System.Boolean]
        $ClientMediaPortRangeEnabled,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Teams Client"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $dscContent = ''
        $params = @{
            Identity           = "Global"
            Credential = $Credential
        }
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
