Attribute VB_Name = "sc4Format"
Sub sc4fmt()
    Application.PrintCommunication = False
    With ActiveSheet.PageSetup
        .FitToPagesWide = 1
        .FitToPagesTall = 0
    End With
    Application.PrintCommunication = True
    
    
    '
    ' Save code to git
    '
    ExportVisualBasicCode
End Sub
