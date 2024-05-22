Attribute VB_Name = "sc4Format"
Sub sc4fmt()
    Application.PrintCommunication = False
    With ActiveSheet.PageSetup
        ' Fit to page width
        .FitToPagesWide = 1
        .FitToPagesTall = 0
     
        .LeftMargin = Application.InchesToPoints(0.236220472440945)
        .RightMargin = Application.InchesToPoints(0.236220472440945)
        .TopMargin = Application.InchesToPoints(0.31496062992126)
        .BottomMargin = Application.InchesToPoints(0.31496062992126)
        .HeaderMargin = Application.InchesToPoints(0.31496062992126)
        .FooterMargin = Application.InchesToPoints(0.31496062992126)
        
        .OddAndEvenPagesHeaderFooter = False
        .DifferentFirstPageHeaderFooter = False
        
        .LeftHeader = ""
        .CenterHeader = ""
        .RightHeader = ""
        .LeftFooter = ""
        .CenterFooter = ""
        .RightFooter = ""
    End With
    Application.PrintCommunication = True
    
    ' Set font
    With ActiveSheet.Cells.Font
        .Name = "Courier New"
        .Size = 12
    End With
    
    ' Fiddle column widths
    ActiveSheet.Columns(1).ColumnWidth = 9.29
    For i = 1 To 7
      ActiveSheet.Columns(2 * i).ColumnWidth = 7.86
      ActiveSheet.Columns(2 * i + 1).ColumnWidth = 3.57
    Next i
    
    
    '
    ' Save code to git
    '
    ExportVisualBasicCode
End Sub
