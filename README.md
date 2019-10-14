# NetApp Auto Aggregate Evacuation

#### Date: 14-10-2019
#### Version: 1
#### Blog: www.sysadmintutorials.com
#### Twitter: @systutorials

## Description

Have yopu ever had the need to completely evacuate all volumes off an existing aggregate ? You know that the process can take some time.
This Data ONTAP PowerShell script will automate the process for you.

A good use case for this script is the decomissioning of an existing aggregate.

## File Listing & Description
1. netapp_aggregate_evacuate.ps1<br>
   
   This Data ONTAP script is part of my blog post. Please visit the link below for a complete run down of how the script works:<br>
   https://www.sysadmintutorials.com/netapp-auto-aggregate-volume-evacuation-with-powershell/<br>
   
   This script is going to vol move all volumes (excluding any root volumes) from a source aggregate to a destination aggregate. There is a limit of 4 vol moves at any 1 time.
   
   Within the script please change the following:<br>
   
     a. Line 12 - Connect-NcController 192.168.1.50 -credential $netappcreds (replace 192.168.1.50 with your cluster IP or DNS name)<br>
     b. Line 32 and 35 - $evacaggr (source aggregate) and $destaggr (destination aggregate) variables.
  
