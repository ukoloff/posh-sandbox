Attribute VB_Name = "sc4Format"
Sub sc4fmt()
    Application.PrintCommunication = False
    With ActiveSheet.PageSetup
        ' Fit to page width
        .FitToPagesWide = 1
        .FitToPagesTall = 0
     
        .CenterHorizontally = True
        .CenterVertically = True
     
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
    RestoreRawSheet
    
    Dim chunk, extra, N, pages, i, j As Integer
    Dim wnd As Range
    chunk = 52
    extra = 3
    Set wnd = Cells(chunk - extra + 1, 1).Resize(extra, 15)
    
    N = ActiveSheet.Cells.SpecialCells(xlCellTypeLastCell).Row
    pages = WorksheetFunction.Ceiling(N / (chunk - extra), 1)
    For i = 1 To pages
            wnd.EntireRow.Insert Shift:=xlDown
        Dim pg As Range
        Set pg = wnd.Offset(-chunk, 0).Resize(chunk, wnd.Columns.count)
        pg.BorderAround ColorIndex = 0 ' , Weight:=xlThick
        ActiveWorkbook.Names.Add Name:="page" & Format(i, "00"), RefersTo:=pg
        ActiveWindow.SelectedSheets.HPageBreaks.Add Before:=wnd
        Set wnd = wnd.Offset(-wnd.Rows.count, 0)
        wnd.BorderAround ColorIndex = 0 ' , Weight:=xlThick
        ' wnd.Interior.Color = 65535
        ActiveWorkbook.Names.Add Name:="footer" & Format(i, "00"), RefersTo:=wnd
        Set wnd = wnd.Offset(chunk, 0)
    Next i
    
End Sub
