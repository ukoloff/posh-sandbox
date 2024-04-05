﻿# https://github.com/mturnaviotov/shell_scripts/blob/master/PowerShell/SendNetworkMessageByRDP.ps1
# Version 2.6
# This script allow you to sent message via net msg from windows to all users of rdp server farm, or others
# no out
$ErrorActionPreference = "silentlycontinue"

# Join our .Net Forms
Add-Type -assembly System.Windows.Forms

# Server, User list, default signature
$Server        = @("rdp1, rdp2, rdp3, rdp4")
$User          = @("*")
$Message       = "Превед, медвед!"

# TODO add alter if default message not changed
# default signature 
$Sign          = @("WBR, support team support@domain.com", "WBR, admin's team support@domain.com")

# Send a message there. If the checkbox for the Test run is active - use only message for localhost
Function SendMessage {
        param ($Server, $User, $Message, $Sign)
        If ($TestRunCheckBox.Checked -eq 1 ) { Write-Host $TestRunCheckBox.Checked; $Server="localhost"; $User = "Console" }
        ForEach ($Item in $Server) {
            ForEach ($UserN in $User) {
                    $UserTrim = $UserN.Trim()
                    $ServerTrim = $Item.Trim()
                    $MsgTrim = $Message.Trim()
                    $SignTrim = $SignX.Trim()
                    c:\windows\system32\msg.exe $UserTrim /Server:$ServerTrim $MsgTrim $SignTrim
                }
        }
     # Confirm
    }

# Confirm 
Function Confirm {
        $ConfirmWin = New-Object System.Windows.Forms.Form
        $ConfirmWin.StartPosition  = "CenterScreen"
        $ConfirmWin.Text = "Confirm sending"
        $ConfirmWin.Width = 200
        $ConfirmWin.Height = 120
        $ConfirmWin.ControlBox = 0
        $ConfirmWinOKButton = New-Object System.Windows.Forms.Button
        $ConfirmWinOKButton.add_click({ $MainSendWindow.Close(); $ConfirmWin.Close() })
        $ConfirmWinOKButton.Text = "Close"
        
        $ConfirmWinOKButton.AutoSize = 1
        $ConfirmWinOKButton.Location = New-Object System.Drawing.Point(50,50)

        $ConfirmLabel = New-Object System.Windows.Forms.Label
        $ConfirmLabel.Text = "Message was sent"
        $ConfirmLabel.AutoSize = 1
        $ConfirmLabel.Location = New-Object System.Drawing.Point(10,10)
        $ConfirmWin.Controls.Add($ConfirmLabel)
        $ConfirmWin.Controls.Add($ConfirmWinOKButton)
        $ConfirmWin.ShowDialog() | Out-Null
    }
    
$MainSendWindow                = New-Object System.Windows.Forms.Form
$ToolTip = New-Object System.Windows.Forms.ToolTip

$ToolTip.BackColor = [System.Drawing.Color]::LightGoldenrodYellow
$ToolTip.IsBalloon = $true
# $ToolTip.InitialDelay = 500
# $ToolTip.ReshowDelay = 500

$SendButton                    = New-Object System.Windows.Forms.Button
$CloseButton                   = New-Object System.Windows.Forms.Button
$TestRunCheckBox               = New-Object System.Windows.Forms.CheckBox

$ServerTextBox                 = New-Object System.Windows.Forms.ComboBox
$UserTextBox                   = New-Object System.Windows.Forms.ComboBox
$MessageTextBox                = New-Object System.Windows.Forms.TextBox
$SignTextBox                   = New-Object System.Windows.Forms.ComboBox

$ServerTextBoxLabel            = New-Object System.Windows.Forms.Label
$UserTextBoxLabel              = New-Object System.Windows.Forms.Label
$MessageTextBoxLabel           = New-Object System.Windows.Forms.Label
$SignTextBoxLabel              = New-Object System.Windows.Forms.Label

$MainSendWindow.StartPosition  = "CenterScreen"
$MainSendWindow.Text           = "Send message for the users"
$MainSendWindow.Width          = 470
$MainSendWindow.Height         = 220

$ServerTextBoxLabel.Location   = New-Object System.Drawing.Point(10,12)
$ServerTextBoxLabel.Text       = "Servers list"

$UserTextBoxLabel.Location     = New-Object System.Drawing.Point(10,42)
$UserTextBoxLabel.Text         = "Users list"
$UserTextBoxLabel.Autosize     = 1

$MessageTextBoxLabel.Location  = New-Object System.Drawing.Point(10,73)
$MessageTextBoxLabel.Text      = "Message for delivery"
$MessageTextBoxLabel.Autosize  = 1
$ToolTip.SetToolTip($MessageTextBoxLabel, "Message text")

$SignTextBoxLabel.Location     = New-Object System.Drawing.Point(10,103)
$SignTextBoxLabel.Text         = "Signature"
$SignTextBoxLabel.Autosize     = 1
$ToolTip.SetToolTip($SignTextBoxLabel, "Sign please, no sender name in destination message box")

$ServerTextBox.Location        = New-Object System.Drawing.Point(140,10)
$ServerTextBox.DataSource      = $Server
$ServerTextBox.Width           = 300
$ServerTextBox.add_TextChanged({ $Server = $ServerTextBox.Text })
$ServerTextBox.TabIndex        = 1
$ToolTip.SetToolTip($ServerTextBox, "Servers list")

$UserTextBox.Location          = New-Object System.Drawing.Point(140,40)
$UserTextBox.DataSource        = $User
$UserTextBox.Text              = $User[1]
$UserTextBox.add_click({ $UserTextBox.SelectAll() })
$UserTextBox.add_TextChanged({ $UserX = $UserTextBox.Text })
$UserTextBox.Width             = 300
$UserTextBox.TabIndex          = 2
$ToolTip.SetToolTip($UserTextBox, "Recipient list? (* for *all* users, by default)")

$MessageTextBox.Location       = New-Object System.Drawing.Point(140,70)
$MessageTextBox.Text           = $Message
$MessageTextBox.add_click({ $MessageTextBox.SelectAll() })
$MessageTextBox.add_TextChanged( { $Message = $MessageTextBox.Text })
$MessageTextBox.Width          = 300
$MessageTextBox.TabIndex       = 3
$ToolTip.SetToolTip($MessageTextBox, "What we will sent?")

$SignTextBox.Location          = New-Object System.Drawing.Point(140,103)
$SignTextBox.DataSource        = $Sign
$SignTextBox.Text              = $Sign[1]
$SignTextBox.add_TextChanged({ $Sign = $SignTextBox.Text })
$SignTextBox.Width             = 300
$SignTextBox.TabIndex          = 4
$ToolTip.SetToolTip($SignTextBox, "Who is the  author?")

$SendButton.Location           = New-Object System.Drawing.Point(10,150)
$SendButton.Text               = "Send"
$SendButton.add_click({ 
    $User  = $UserTextBox.Text.Split(","); 
    $Server = $ServerTextBox.Text.Split(","); 
    $SignX = $SignTextBox.Text; 
    SendMessage $Server $User $Message $SignX} )
$SendButton.Autosize           = 1
$SendButton.TabIndex           = 5
$ToolTip.SetToolTip($SendButton, "Send now")


$TestRunCheckBox.Location      = New-Object System.Drawing.Point(200,150)
$TestRunCheckBox.Text          = "Тест"
$TestRunCheckBox.Checked       = 1
$TestRunCheckBox.AutoSize      = 1
$TestRunCheckBox.TabIndex      = 6
$ToolTip.SetToolTip($TestRunCheckBox, "Test sending, only for localhost")

$CloseButton.Location          = New-Object System.Drawing.Point(315,150)
$CloseButton.Text              = "Exit/Close"
$CloseButton.add_click({ $MainSendWindow.Close() })
$CloseButton.Autosize          = 1
$CloseButton.TabIndex          = 7
$ToolTip.SetToolTip($CloseButton, "Stop script")

$MainSendWindow.Controls.Add($SendButton)
$MainSendWindow.Controls.Add($TestRunCheckBox)
$MainSendWindow.Controls.Add($CloseButton)

$MainSendWindow.Controls.Add($ServerTextBox)
$MainSendWindow.Controls.Add($UserTextBox)
$MainSendWindow.Controls.Add($MessageTextBox)
$MainSendWindow.Controls.Add($SignTextBox)

$MainSendWindow.Controls.Add($ServerTextBoxLabel)
$MainSendWindow.Controls.Add($UserTextBoxLabel)
$MainSendWindow.Controls.Add($MessageTextBoxLabel)
$MainSendWindow.Controls.Add($SignTextBoxLabel)

$MainSendWindow.ShowDialog() | Out-Null
# Confirm
