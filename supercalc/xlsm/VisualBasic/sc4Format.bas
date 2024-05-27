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
    
    
    '
    ' Save code to git
    '
    ExportVisualBasicCode
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
        ActiveSheet.Names.Add Name:="page_" & Format(i, "00"), RefersTo:=pg
        ActiveWindow.SelectedSheets.HPageBreaks.Add Before:=wnd
        Set wnd = wnd.Offset(-wnd.Rows.count, 0)
        wnd.BorderAround ColorIndex = 0 ' , Weight:=xlThick
        ' wnd.Interior.Color = 65535
        ActiveSheet.Names.Add Name:="footer_" & Format(i, "00"), RefersTo:=wnd
        
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
            Else
                .Formula = "=" & .Offset(-chunk, 0).Address(0, 0)
            End If
            .HorizontalAlignment = xlCenter
            .Font.Size = 16
            .Borders(xlEdgeLeft).ColorIndex = 0
        End With
        With wnd.Range("H2:M2")
            .Merge
            If i = 1 Then
                .Value = Nomer
            Else
                .Formula = "=" & .Offset(-chunk, 0).Address(0, 0)
            End If
            .HorizontalAlignment = xlCenter
            .Font.Size = 14
            .Borders(xlEdgeLeft).ColorIndex = 0
        End With
        Set wnd = wnd.Offset(chunk, 0)
    Next i
    
End Sub

Sub dePaginate()
    Dim N
    ActiveSheet.ResetAllPageBreaks
    For Each N In ActiveSheet.Names
        If InStr(N.Name, "footer_") Then
            N.RefersToRange.EntireRow.Delete
        End If
        If InStr(N.Name, "page_") Then
            N.RefersToRange.Borders.LineStyle = xlNone
        End If
    Next N
    For Each N In ActiveSheet.Names
        N.Delete
    Next N
    ActiveSheet.UsedRange
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
    sc4fmt
    If Not IsError(Evaluate("PRN!A1")) Then
        Application.DisplayAlerts = False
        Sheets("PRN").Delete
        Application.DisplayAlerts = True
    End If
    Dim src
    Set src = ActiveSheet
    src.Copy After:=src
    Worksheets(src.Index + 1).Name = "PRN"
    src.Select
End Sub
