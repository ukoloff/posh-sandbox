Attribute VB_Name = "Utils"
Sub RestoreRawSheet()
Attribute RestoreRawSheet.VB_ProcData.VB_Invoke_Func = " \n14"
    Application.DisplayAlerts = False
    Sheets("SandBox").Delete
    Application.DisplayAlerts = True
    Dim src
    Set src = Sheets("Raw")
    src.Copy Before:=src
    Dim dst
    Set dst = Sheets(src.Index - 1)
    dst.Name = "SandBox"
    dst.Unprotect
End Sub
