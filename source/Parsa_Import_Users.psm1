<#
------------------------------------------------------------------------------------------------------------
NAME           Parsa_Import_csv

Project        Import Users from a csv file
Description    Import users from a csv file, add them to the selected OU by the user
               After the user is created then create home directories based on the username
               in the desired location.

Author         Parsa Hashemi
Studenet ID    20002363
Date           22-11-2018

Class          Network Scripting
Course         Cert IV in Information Technology and Networking
Group          B
------------------------------------------------------------------------------------------------------------
#>

<#
.SYSNOPIS
This Script adds new user accounts.

.DESCRIPTION
This Script adds new user accounts on any domain, OU and creates
home directories for each user in a location specified by the user.

.PARAMETER OU_Name
Used to specify name of the OU that new users are created.

.PARAMETER csv_File_Path
Used to specify the directory of the .csv file.

.PARAMETER User_Home_Directory_Path
Used to to speccify the path of users' home directories.
#>


#create a function called download_csv_user and include { the following ...
function Parsa_Import_csv {


#naming parameters
param (
    
    #parameter named OU_Name and make it mandatory* 
    [Parameter(Mandatory=$true)][String]$OU_Name,

    #parameter named csv_File_Path and make it mandatory* 
    [Parameter(Mandatory=$true)][String]$csv_File_Path,

    #parameter named Drive_Letter and make it mandatory* 
    [Parameter(Mandatory=$true)][String]$Drive_Letter,

    #parameter named User_Home_Directory_Path and make it mandatory* 
    [Parameter(Mandatory=$true)][String]$User_Home_Directory_Path
   
    #*mandatory: prompt and ask for a value from the user
)

#Get current date and time and format it into dd-MM-yyyy--HH-mm-ss
$CurrentDate = Get-Date -format "dd-MM-yyyy--HH-mm-ss"

#Start the transcript and save in C:\Logs_Parsa and add '$CurrentDate' in front of 'Log_' so it won't overwrite previous logs
Start-Transcript -Path C:\Logs_Parsa\Log_"$CurrentDate".txt
 
#See if $csv_File_Path variable which was received from client is a valid path or not

#If it's not then do this ...
if (-not (Test-Path $csv_File_Path))
        {
	        write-host	-ForegroundColor Yellow  "Cannot find csv file path '$csv_File_Path'. Please try again ..."
	        download_csv_user;
        }
#if it's valid the do this ...
        else
        {
            #Get everthing from the .csv file and format it in a table
	        Import-Csv $csv_File_Path | Format-Table 
        }

#See if Active Directory module is imported. If not, then import it
        try{
            Import-Module activedirectory -ErrorAction SilentlyContinue
        }

#If Active Directory module can't be imported then show the following message and exit the program
        catch{
            Write-Host -ForegroundColor Yellow "Active Directory module can't be loaded :("
            exit
        }

#Get the item at the specified location written by $csv_File_Path variable
$File = Get-Item $csv_File_Path -ErrorAction SilentlyContinue

#If the csv file is available and usable do the following ...
if ([System.IO.File]::Exists($File.FullName)) {
        
        #Run the following scripted located at the same location as this script
        cd "C:\Program Files\WindowsPowerShell\Modules\Parsa_Import_Users\"
        .\Password_P.ps1

        #Read it back in to get the SecureString
        $Passwd = Get-Content ".\credentials.txt" | ConvertTo-SecureString

        #Since this module is supposed to run on any AD, locate the current AD context
        $DomainPath = Get-ADDomain | select -ExpandProperty DistinguishedName 

        #OU path is made of two variables, 1. $OU_Name (Specified by the client) and 2. $DomainPath (Current AD in this machine)
        $OUPath = "OU=$OU_Name,$DomainPath"
        $ADUsers = Import-csv $csv_File_Path

}

       #If this OU DOES NOT exist then create one with the exact name received from $OU_Name variable 
	   if (! [ADSI]::Exists("LDAP://OU=$OU_Name,$DomainPath")){
	      New-ADOrganizationalUnit -Name “$OU_Name” –path $DomainPath
	   }
        
       #See if the entered home directory exists. If not then create one with the exact name received from $User_Home_Directory_Path variable 
       if( -Not (Test-Path -Path $User_Home_Directory_Path)){
		  New-Item -ItemType Directory -Name Home -Path $User_Home_Directory_Path
	   }
        

       #Start of the loop
       #This loop reads row by row from the .csv file
       #First it reads the headings and assigns each to a variable. i.e. 'Depart' in .csv would be $Department in the script
       #After it assigns the headings to an appropriate variable, it starts reading users one by one (row by row)
       #Later each user account is created with their properties same as .csv file 

       #Read a user from the csv and assign $User to them till this loop finishes
       foreach ($User in $ADUsers) {
            
            $Principal = "$($Domain.DistinguishedName)" 
            
            $NetAccount	= $User.NetAccount
            $FullName 	= $User.FullName
	        $FstName 	= $User.FstName
	        $LstName 	= $User.LstName
	        $Title 		= $User.Title
            $Department = $User.Depart
            

            #If user does exist, give a warning 
            if (Get-ADUser -F {SamAccountName -eq $NetAccount}){

		    Write-Warning " $NetAccount user account already exists in Active Directory."

	        }

            #If user does not exist then do the following ...

            #New Active Directory user with the following properties
            else
            {

                   New-ADUser `
                        -SamAccountName $NetAccount `
                        -Name "$FstName $LstName" `
                        -GivenName $FstName `
                        -Surname $LstName `
                        -Enabled $True `
                        -DisplayName "$Lstname $Fstname" `
                        -Title $Title `
                        -Department $Department `
                        -AccountPassword $Passwd `
                        -HomeDrive $Drive_Letter `
                        -HomeDirectory "$Drive_Letter\$User_Home_Directory_Path\$NetAccount" `
                        -path $OUPath                  
            
                #Since the user is created, give a message with the user's first name and last name their unique username
                Write-Host -ForegroundColor Green "$FstName $LstName's account with '$NetAccount' username has been created."

                #This is to find the exact user's home folder since their home folder name is the same as their unique account name ($NetAccount)
                $fullPath = "$Drive_Letter\$User_Home_Directory_Path\$NetAccount"

                #$User is assigned a value by their $Netaccount
                $User = Get-ADUser -Identity $NetAccount
                
                #If $User is not EMPTY then do the following ...
                if($User -ne $Null) {


                    #Set a home directory to this user ($User)
                    Set-ADUser $NetAccount -HomeDrive $Drive_Letter -HomeDirectory $fullPath -ea Stop

                    #Creat a directory in the address as the path a home directory was assigned to the user (previous user)
                    $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop
                    
                    #To be able to proceed we need a reference to the ACL of the newly created directory.
                    $acl = Get-Acl $homeShare
                    
                    <#
                    we want to add a new FileSystemAccessRule to this ACL that contains the relevant access rules. 
                    There is a corresponding .NET object which we can adjust according to the requirements. 
                    First, we define the specifications that set the authorizations and inheritances with the help 
                    of further .Net objects. In this instance, we want to authorize the user to create (and change) 
                    new files and folders. To implement, we define the following properties:
                    #>
                    $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
                    $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow

                    <#
                    Additionally, we have to define the inheritance. Normally you want the user to be able to change 
                    all the subfolders and files within as well. Hence, we define the properties as follows ... 
                    #>
                    $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
                    $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
                    
                    <#
                    Now we have all properties necessary to create a new FileSystemAccessRule object. However, the 
                    object needs to know to whom to assign the access rights. Since we have already selected the user, 
                    we can include his Security Identifier (SID):
                    #>
                    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
                    
                    #Simply add the new access rule to the ACL we used before.
                    $acl.AddAccessRule($AccessRule)
 
                    <#
                    Finally you have to update the ACL of the directory. We have to overwrite the old one with the 
                    new ACL, which consists of the old ACL and our new entry:
                    #>
                    Set-Acl -Path $homeShare -AclObject $acl -ea Stop
                    Write-Host -ForegroundColor Cyan ("$NetAccount's home directory created at {0}" -f $fullPath)
                }

            }
            }
        
            #Read a user from the csv and assign $User to them till this loop finishes
            foreach ($User in $ADUsers) {
                        
                        #Splits a string into substrings
                        $temp = $($User.Super).split(".")

                        #Locating super
                        $super = "CN=$($temp[0]) $($temp[1]),OU=$OU_Name,$DomainPath"
                        $U = $User.NetAccount


                        try{
                            #Set a manager to this user
                            Set-ADUser $U -Manager "$Super" -ea SilentlyContinue

                        }

                        catch{}
                        
        }

           #Stop the transcript
           Stop-Transcript
        }
# SIG # Begin signature block
# MIII8AYJKoZIhvcNAQcCoIII4TCCCN0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUK9P7RmSh7DqQvWIXuxacd9TK
# BKOgggZbMIIGVzCCBT+gAwIBAgITWQAAIPiIGXsokC0T6gAAAAAg+DANBgkqhkiG
# 9w0BAQsFADBHMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJkiaJk/IsZAEZ
# FgN0ZG0xGTAXBgNVBAMTEHRkbS1HQUxBRFJJRUwtQ0EwHhcNMTgxMTIyMDcwODQ4
# WhcNMTkxMTIyMDcwODQ4WjBXMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJ
# kiaJk/IsZAEZFgN0ZG0xETAPBgNVBAsTCFN0dWRlbnRzMRYwFAYDVQQDEw1QQVJT
# QSBIQVNIRU1JMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApeysVB8/
# MlCNQNMMIq1/mruk1axc+gjRAJ/9Iu/rJ7MidoIgIGBEwGQul+hyCmAKiICqjFIk
# 9197s7zVHPU9ehru9o+qGy3Gnx1a9FNEGyXih0f3FQbtZCV5ZoT4qTFZULZ31Ld0
# wpngPaUYehIU6FxoZiXdEOPgFNWDMR2D5elcosNzz3nVDacDyXSaRaFBSIPKP1/P
# NFgrm0Os3pWtI66A10UU3+GpwSdMSteUd/FpjeQjxzU/6Zs85RhWCQidIx1k1m+v
# /wFAF7dcYzT7PLltF8s2yGUMRrSODabrfTUL7u2oyjblydeblSs7V4leyl8vckqm
# X/ALG9Ja6Mg4MQIDAQABo4IDKjCCAyYwOwYJKwYBBAGCNxUHBC4wLAYkKwYBBAGC
# NxUIiMNz2Z1ogp2RLISi6GSHyuppEIKL7hmE9bUNAgFlAgECMD8GA1UdJQQ4MDYG
# CisGAQQBgjcKAwwGCCsGAQUFBwMDBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQB
# gjcKAwQwDgYDVR0PAQH/BAQDAgXgME8GCSsGAQQBgjcVCgRCMEAwDAYKKwYBBAGC
# NwoDDDAKBggrBgEFBQcDAzAKBggrBgEFBQcDAjAKBggrBgEFBQcDBDAMBgorBgEE
# AYI3CgMEMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwICAgCAMA4GCCqGSIb3
# DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQUoLXvseOFWfU/
# uFvr53uPiQv0YbUwHwYDVR0jBBgwFoAUiNpZxSaBQ8BeL9I84DbDo1Hl9k8wgc4G
# A1UdHwSBxjCBwzCBwKCBvaCBuoaBt2xkYXA6Ly8vQ049dGRtLUdBTEFEUklFTC1D
# QSxDTj1HQUxBRFJJRUwsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2Vz
# LENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9dGRtLERDPWxvY2FsP2Nl
# cnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0
# cmlidXRpb25Qb2ludDCBwAYIKwYBBQUHAQEEgbMwgbAwga0GCCsGAQUFBzAChoGg
# bGRhcDovLy9DTj10ZG0tR0FMQURSSUVMLUNBLENOPUFJQSxDTj1QdWJsaWMlMjBL
# ZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXRk
# bSxEQz1sb2NhbD9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlm
# aWNhdGlvbkF1dGhvcml0eTArBgNVHREEJDAioCAGCisGAQQBgjcUAgOgEgwQSEFT
# SEVQQHRkbS5sb2NhbDANBgkqhkiG9w0BAQsFAAOCAQEAiq/BeBbCplWxILRrqUP7
# D7l3sD4d3cSQGyTZW5UGP8zxf5ssFQpr7Oiyb6p/fAYZIHoRic7XwZH34/BTB9zF
# YLJqZX/Eku7fOPbwO6LFxwipT0Icc2zt78/68jW0T+bsgKwQhnSb9ZrwWtiqO02g
# mB5uV4vr5bvNNHr4oDzkznK+yy/Tv5ah6JQbLqsrficumpRqZw6X2Xfcw98EGh+J
# YXkL1op5NF/b3m25cKvxYVCRoMVTVnDLGRs2SWngihIOwpYHIM026m6Ojn4Xc0M/
# rPLlat2fJ5maZjxf3v+dvuBvuEmQp1q+yRUH3MhZSVfpFfj2X3P6S5baBJKEHdi8
# rzGCAf8wggH7AgEBMF4wRzEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRMwEQYKCZIm
# iZPyLGQBGRYDdGRtMRkwFwYDVQQDExB0ZG0tR0FMQURSSUVMLUNBAhNZAAAg+IgZ
# eyiQLRPqAAAAACD4MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgACh
# AoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAM
# BgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBTGk02NxpCfA2vE5ndLC8JaVIA8
# KjANBgkqhkiG9w0BAQEFAASCAQBOksuIoVOPSM+mjf3Dezz+hP0yCT5CgvGQuxjo
# KaGOjwIS/H1j3GSuJHw8eOUAuOLddIqLkCStb4Cxa5G+sT0A0FS//4Sp94edsqiY
# ceeiu7zgbPY+oAZmbW+KHgSO4VuqBUfRdgDy1ly4QMDBksuVob4VZUp+TQ2JWfoS
# DHMEOBPPhaYZbEf9vvXA3PJpJlzC5LTnhs5uNJq2tI6PcScESA1AKwH0gqkfp4ZZ
# D0B32qeW62yTWt8NyNg/x0hGCkLdtdOj3MWlg9nKCHTdE0AU4vZdY2QrqTWK5ciD
# QfEHjg1n7T4XQxM4eFaJ+Ib2YEabI2N0ERYgoAazfYRfexQU
# SIG # End signature block
