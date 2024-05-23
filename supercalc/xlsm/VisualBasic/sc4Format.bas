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
        
        '.LeftHeader = ""
        .CenterHeader = ""
        '.RightHeader = ""
        '.LeftFooter = ""
        .CenterFooter = ""
        '.RightFooter = ""
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


Sub Paginate()
    Dim chunk, extra, N, pages, i, j As Integer
    Dim wnd As Range
    chunk = 50
    extra = 3
    Set wnd = Cells(chunk - extra + 1, 1).Resize(extra, 15)
    
    N = ActiveSheet.Cells.SpecialCells(xlCellTypeLastCell).Row
    pages = WorksheetFunction.Ceiling(N / chunk, 1)
    For i = 1 To pages
        wnd.EntireRow.Insert Shift:=xlDown
        Set wnd = wnd.Offset(-extra, 0)
        wnd.Interior.Color = 65535
        Set wnd = wnd.Offset(chunk, 0)
    Next i
    
End Sub
