$Rem = 'UXM0048'

Invoke-Command -ComputerName $Rem -ScriptBlock { Stop-Service IPSUpdater }
