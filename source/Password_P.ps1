<#
------------------------------------------------------------------------------------------------------------
Project        Converts encrypted standard string to a secure string
Description    Converts encrypted standard string to a secure string and saves
               it inside a .txt file

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
Converts encrypted standard string to a secure string

.DESCRIPTION
Converts encrypted standard string to a secure string and saves it inside a .txt file

#>

#Convert encrypted standard string to a secure string and save it here: "C:\Program Files\WindowsPowerShell\Modules\Parsa_Import_Users\credentials.txt"
ConvertTo-SecureString "Pa55w.rd2018" -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\Program Files\WindowsPowerShell\Modules\Parsa_Import_Users\credentials.txt"

# SIG # Begin signature block
# MIII8AYJKoZIhvcNAQcCoIII4TCCCN0CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU70FCvdZEH+zxBeVF2PTSNjvo
# J2KgggZbMIIGVzCCBT+gAwIBAgITWQAAIPiIGXsokC0T6gAAAAAg+DANBgkqhkiG
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
# BgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSn6AUieXIpJgYx24k2cUCiQktN
# ZDANBgkqhkiG9w0BAQEFAASCAQA1A9dFUqeLl/youfzc3E5vGnuh3ejz+sviGMl7
# 6O2iMI2je2DKTQJHPgBbNi1O++x/iWZIoTM9HY0iWbICp/1tMSDIwJUQu89hgeSA
# XtFzMZvFnnM+F4HFVw6D7+vbebdP+G4LIfdJbLO4Dw6HanlFjjJnpFZJgEg8u3+/
# 2dLSoQ0MseLsM6X/puSSJDt0IQr3EwTS0RxBcIEvZV+QUXcmrE38wylnRkHKVeI+
# 8CWBM2Db614MkKwZcNUUC5d1JNXriGsH1SOEGxzjtjpFGvx58K84w9D+3Li561oy
# wl3Wh0BWl8KHM9hT7ppt1aNayp9aYFRUfEmciMmWQOkx2uu3
# SIG # End signature block
