# Import Modules
IF (-not (Get-Module -Name DataOntap)) {
        Import-Module DataOntap
    }

# Get-Credentials
$netappcreds = Get-Credential -Message "Enter your NetApp Storage Credentials"

# Connect to storage systems
Function connect-netapp
    {
    Connect-NcController 192.168.1.50 -credential $netappcreds
    }

Function getvolmoves
    {
    # Get List of current volmoves
    $global:currentvolmoves = Get-NcVolMove | Where {$_.State -eq "healthy"}
    $global:counter = 0

    ForEach ($volmove in $currentvolmoves)
        {
        $global:counter++
        Write-Host $volmove.Volume "is still moving to" $volmove.DestinationAggregate "- Percent Complete =" $volmove.PercentComplete -ForegroundColor Yellow
        }
    }

# Connect to storage system
connect-netapp

# Aggregate to evacuate
$evacaggr = "aggr1_CLUSTER96_01_data"

# Destination aggregate
$destaggr = "aggr2_CLUSTER96_01_data"

# Get list of volumes on aggregate
$listofvols = Get-NcVol | Where {$_.Aggregate -like $evacaggr -and $_.Name -notlike "*root*"}

ForEach ($vol in $listofvols)
    {

    # Look for vol match in list of current vols
    $volmovematch = Get-NcVolMove | Where {$_.Volume -eq $vol.Name}
    
    getvolmoves

    IF ($global:counter -ge 4)
        {
        Do
            {
            $date = (Get-Date).Tostring("HH:mm")
            Write-Host "$date - Vol move counter is greater than 4, sleeping 5 mins..." -ForegroundColor Yellow
            sleep 300
            getvolmoves
            }
        Until ($global:counter -lt 4)
        }
    
           
    IF (!$volmovematch -and $global:counter -lt 4)
            {
            Write-Host "vol move counter is = " $global:counter
            Write-Host $vol.name "is now moving" -ForegroundColor Green
            Start-NcVolMove -DestinationAggregate $destaggr -Vserver $vol.Vserver -Name $vol.Name
            }
    }
