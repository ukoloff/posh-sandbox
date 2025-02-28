On Error Resume Next

Set objWord = CreateObject("Word.Application")
Set objDoc = objWord.Documents.Add()

strLogo = "\\omzglobal.com\SysVol\omzglobal.com\scripts\Bin\signatures\HimEnergo\logo_HE.png"

Set objSysInfo = CreateObject("ADSystemInfo")
Set objUser = GetObject("LDAP://" & objSysInfo.UserName)

objDoc.Range.Delete
objDoc.Paragraphs.SpaceAfter = 0
objDoc.Paragraphs.LineSpacingRule = wdLineSpaceSingle

Set t = objDoc.Tables.Add(objDoc.Range, 6, 2)

t.Range.Font.Name = "WeblySleek UI Semibold"
t.Range.Font.Size = 9

t.Columns(1).Cells.Merge
t.Range.Cells(1).Width = 134
t.Range.Cells(1).Range.InlineShapes.AddPicture strLogo

Set c2 = t.Columns(2)

With c2.Cells(1).Range
    .Font.Size = 10
    .Font.Bold = True
    .Text = objUser.givenName & vbCrLf & objUser.sn
End With

c2.Cells(2).Range.Text = objUser.Title

strMobile = digitsOnly(objUser.mobile)
If strMobile <> "" Then
    c2.Cells(3).Range.Text = "+7 (" & Mid(strMobile, 2, 3) & ") " & Mid(strMobile, 5, 3) & "-" & Mid(strMobile, 8, 2) & "-" & Right(strMobile, 2) & vbCrLf
End If

c2.Cells(4).Range.Text = "Хибиногорский пер., 33" & vbCrLf & "Екатеринбург, 620010"

intPhone = digitsOnly(objUser.otherTelephone)
dopPhone = ""
If Left(intPhone, 1) = "6" Then
    tel7 = "3100956"
    dopPhone = " доп. " & intPhone
End If

If IsEmpty(tel7) Then
    tel7 = Right(digitsOnly(objUser.telephoneNumber), 7)
End If

If tel7 <> "" Then
    c2.Cells(5).Range.Text = "+7 (343) " & Left(tel7, 3) & "-" & Mid(tel7, 4, 2) & "-" & Right(tel7, 2) & dopPhone
End If

objWord.Visible = True

Function digitsOnly(s)
    Rem Only digits
    Result = ""
    For i = 1 To Len(s)
        c = Mid(s, i, 1)
        If IsNumeric(c) Then Result = Result & c
    Next
    digitsOnly = Result
End Function

