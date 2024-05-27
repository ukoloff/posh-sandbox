Attribute VB_Name = "sc4Format"
Sub sc4fmt()
    Application.PrintCommunication = False
    With ActiveSheet.PageSetup
        ' Fit to page width
        .FitToPagesWide = 1
        .FitToPagesTall = 0
     
        .CenterHorizontally = True
        .CenterVertically = True
     
        .LeftMargin = Application.InchesToPoints(0.78740157480315)
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
End Sub


Sub AddPages(Title, Nomer)
    Dim chunk, extra, N, pages, i, j As Integer
    Dim wnd As Range
    chunk = 55
    extra = 2
    Set wnd = Cells(chunk - extra + 1, 1).Resize(extra, 15)
    
    N = ActiveSheet.Cells.SpecialCells(xlCellTypeLastCell).Row
    pages = WorksheetFunction.Ceiling(N / (chunk - extra), 1)
    
    For i = 1 To pages
        wnd.EntireRow.Insert Shift:=xlDown
        Dim pg As Range
        Set pg = wnd.Offset(-chunk, 0).Resize(chunk, wnd.Columns.count)
        pg.BorderAround ColorIndex = 0 ' , Weight:=xlThick
        ' ActiveSheet.Names.Add Name:="page_" & Format(i, "00"), RefersTo:=pg
        ActiveWindow.SelectedSheets.HPageBreaks.Add Before:=wnd
        Set wnd = wnd.Offset(-wnd.Rows.count, 0)
        wnd.BorderAround ColorIndex = 0 ' , Weight:=xlThick
        ' wnd.Interior.Color = 65535
        ' ActiveSheet.Names.Add Name:="footer_" & Format(i, "00"), RefersTo:=wnd
        
        wnd.Show
        DoEvents    ' Update screen
        With wnd.Range("N1").Resize(1, 2)
            .Merge
            .Value = "Ëèñò"
            .HorizontalAlignment = xlCenter
            .Font.Size = 11
            .BorderAround ColorIndex = 0
        End With
        With wnd.Range("N2").Resize(1, 2)
            .Merge
            .Value = i + 1
            .HorizontalAlignment = xlCenter
            .Font.Size = 13
            .BorderAround ColorIndex = 0
        End With
        With wnd.Range("H1:M1")
            .Merge
            If i = 1 Then
                .Value = Title
                ActiveSheet.Names.Add Name:="uxmTitle", RefersTo:=.Cells(1, 1)
            Else
                .Formula = "=uxmTitle"
            End If
            .HorizontalAlignment = xlCenter
            .Font.Size = 16
            .Borders(xlEdgeLeft).ColorIndex = 0
        End With
        With wnd.Range("H2:M2")
            .Merge
            If i = 1 Then
                .Value = Nomer
                ActiveSheet.Names.Add Name:="uxmNomer", RefersTo:=.Cells(1, 1)
            Else
                .Formula = "=uxmNomer"
            End If
            .HorizontalAlignment = xlCenter
            .Font.Size = 14
            .Borders(xlEdgeLeft).ColorIndex = 0
        End With
        Set wnd = wnd.Offset(chunk, 0)
    Next i
    
    With Range("A1")
        .Show
        .Select
    End With
End Sub

Sub Paginate()
    sc4fmt
    
    Dim Title, Nomer As String
    
    Title = "200000000-80-00 PP"
    Nomer = "ÈÍÂ. ¹ 0000000"
    
    If Not IsError(Evaluate("footer_01")) Then
        Dim footer, cell
        Set footer = ActiveSheet.Names("footer_01").RefersToRange
        Set cell = footer.Range("H1")
        If Not IsEmpty(cell.Value) Then Title = cell.Value
        Set cell = footer.Range("H2")
        If Not IsEmpty(cell.Value) Then Nomer = cell.Value
    End If
    
    dePaginate
    
    AddPages Title, Nomer
End Sub

Sub toPrint()
    If ActiveSheet.Name = "PRN" Then
        Worksheets(1).Select
        Exit Sub
    End If
    
    Dim Title, Nomer As String
    
    Title = "200000000-80-00 PP"
    Nomer = "ÈÍÂ. ¹ 0000000"
    
    sc4fmt
    
    If Not IsError(Evaluate("PRN!uxmTitle")) Then Title = Evaluate("PRN!uxmTitle")
    If Not IsError(Evaluate("PRN!uxmNomer")) Then Nomer = Evaluate("PRN!uxmNomer")
    
    If Not IsError(Evaluate("PRN!A1")) Then
        Application.DisplayAlerts = False
        Sheets("PRN").Delete
        Application.DisplayAlerts = True
    End If
    Dim src
    Set src = ActiveSheet
    src.Copy After:=src
    Worksheets(src.Index + 1).Name = "PRN"
    AddPages Title, Nomer
'    src.Select
End Sub
