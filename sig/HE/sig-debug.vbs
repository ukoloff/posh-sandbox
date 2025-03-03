On Error Resume Next
Set objSysInfo = CreateObject("ADSystemInfo")
strUser = objSysInfo.UserName
Set objUser = GetObject("LDAP://" & strUser)



strName = objUser.FullName
strTitle = objUser.Title
strDepartment = objUser.Department
strCompany = objUser.Company
strPhone = objUser.telephoneNumber
strfax = objuser.facsimileTelephoneNumber
strIntPhone = objuser.othertelephone
strEmail = objuser.mail



strName = objUser.FullName
strTitle = objUser.Title
strDepartment = objUser.Department
strCompany = objUser.Company
strDirectPhone = objUser.telephoneNumber
strEmail = objUser.mail
strAddress = Replace(objUser.streetAddress,vbCrLf, ", ")
strPostCode = objUser.postalCode
strCity = objUser.l
strState =  objUser.st
strCountry = objUser.c
'strFax = objUser.fax
strMobile = objUser.mobile
strSwitchPhone = objUser.otherTelephone
strSkype = objUser.ipPhone
strWebsite = objUser.wWWHomePage
strExt = objUser.telephoneAssistant
'strLogo = "\\omzglobal.com\SysVol\omzglobal.com\scripts\Bin\signatures\logo_big_v2.png"
strLogo = "\\omzglobal.com\SysVol\omzglobal.com\scripts\Bin\signatures\HimEnergo\logo_HE.png"
wdColorBlack = 0
wdColorRed = 255
wdColorGray = 5855577

Set objWord = CreateObject("Word.Application")
Set objDoc = objWord.Documents.Add()
Set objSelection = objWord.Selection
Set objEmailOptions = objWord.EmailOptions
Set objSignatureObject = objEmailOptions.EmailSignature
Set objSignatureEntries = objSignatureObject.EmailSignatureEntries
set objRange = objDoc.Range()


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
If Not IsEmpty(strMobile) Then
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


objDoc.Tables.Add objRange,9,9
Set objTable = objDoc.Tables(1)

objdoc.Paragraphs.SpaceAfter = 0

objTable.Cell(1,1).Merge objTable.Cell(2,1)
objTable.Cell(1,1).Merge objTable.Cell(3,1)
objTable.Cell(1,1).Merge objTable.Cell(4,1)
objTable.Cell(1,1).Merge objTable.Cell(5,1)
objTable.Cell(1,1).Merge objTable.Cell(6,1)
objTable.Cell(1,1).Merge objTable.Cell(7,1)
objTable.Cell(1,1).Merge objTable.Cell(8,1)
objTable.Cell(1,1).Merge objTable.Cell(9,1)

objtable.cell(1,1).width = 130

objTable.Cell(1,6).Merge objTable.Cell(1,9)
objTable.Cell(1,6).Merge objTable.Cell(1,8)
objTable.Cell(1,6).Merge objTable.Cell(1,7)
objTable.Cell(1,5).Merge objTable.Cell(1,6)
objTable.Cell(1,4).Merge objTable.Cell(1,5)
objTable.Cell(1,3).Merge objTable.Cell(1,4)
objTable.Cell(1,2).Merge objTable.Cell(1,3)

objTable.Cell(2,6).Merge objTable.Cell(2,9)
objTable.Cell(2,6).Merge objTable.Cell(2,8)
objTable.Cell(2,6).Merge objTable.Cell(2,7)
objTable.Cell(2,5).Merge objTable.Cell(2,6)
objTable.Cell(2,4).Merge objTable.Cell(2,5)
objTable.Cell(2,3).Merge objTable.Cell(2,4)
objTable.Cell(2,2).Merge objTable.Cell(2,3)

objTable.Cell(3,6).Merge objTable.Cell(3,9)
objTable.Cell(3,6).Merge objTable.Cell(3,8)
objTable.Cell(3,6).Merge objTable.Cell(3,7)
objTable.Cell(3,5).Merge objTable.Cell(3,6)
objTable.Cell(3,4).Merge objTable.Cell(3,5)
objTable.Cell(3,3).Merge objTable.Cell(3,4)
objTable.Cell(3,2).Merge objTable.Cell(3,3)

objTable.Cell(4,6).Merge objTable.Cell(4,9)
objTable.Cell(4,6).Merge objTable.Cell(4,8)
objTable.Cell(4,6).Merge objTable.Cell(4,7)
objTable.Cell(4,5).Merge objTable.Cell(4,6)
objTable.Cell(4,4).Merge objTable.Cell(4,5)
objTable.Cell(4,3).Merge objTable.Cell(4,4)
objTable.Cell(4,2).Merge objTable.Cell(4,3)

objTable.Cell(5,6).Merge objTable.Cell(5,9)
objTable.Cell(5,6).Merge objTable.Cell(5,8)
objTable.Cell(5,6).Merge objTable.Cell(5,7)
objTable.Cell(5,5).Merge objTable.Cell(5,6)
objTable.Cell(5,4).Merge objTable.Cell(5,5)
objTable.Cell(5,3).Merge objTable.Cell(5,4)
objTable.Cell(5,2).Merge objTable.Cell(5,3)

objTable.Cell(6,6).Merge objTable.Cell(6,9)
objTable.Cell(6,6).Merge objTable.Cell(6,8)
objTable.Cell(6,6).Merge objTable.Cell(6,7)
objTable.Cell(6,5).Merge objTable.Cell(6,6)
objTable.Cell(6,4).Merge objTable.Cell(6,5)
objTable.Cell(6,3).Merge objTable.Cell(6,4)
objTable.Cell(6,2).Merge objTable.Cell(6,3)

objTable.Cell(7,6).Merge objTable.Cell(7,9)
objTable.Cell(7,6).Merge objTable.Cell(7,8)
objTable.Cell(7,6).Merge objTable.Cell(7,7)
objTable.Cell(7,5).Merge objTable.Cell(7,6)
objTable.Cell(7,4).Merge objTable.Cell(7,5)
objTable.Cell(7,3).Merge objTable.Cell(7,4)
objTable.Cell(7,2).Merge objTable.Cell(7,3)

objTable.Cell(7,6).Merge objTable.Cell(8,9)
objTable.Cell(7,6).Merge objTable.Cell(8,8)
objTable.Cell(7,6).Merge objTable.Cell(8,7)
objTable.Cell(7,5).Merge objTable.Cell(8,6)
objTable.Cell(7,4).Merge objTable.Cell(8,5)
objTable.Cell(7,3).Merge objTable.Cell(8,4)
objTable.Cell(7,2).Merge objTable.Cell(8,3)

objTable.Cell(7,6).Merge objTable.Cell(9,9)
objTable.Cell(7,6).Merge objTable.Cell(9,8)
objTable.Cell(7,6).Merge objTable.Cell(9,7)
objTable.Cell(7,5).Merge objTable.Cell(9,6)
objTable.Cell(7,4).Merge objTable.Cell(9,5)
objTable.Cell(7,3).Merge objTable.Cell(9,4)
objTable.Cell(7,2).Merge objTable.Cell(9,3)


objTable.Cell(1,1).Range.ParagraphFormat.Alignment = wdAlignParagraphRight
objTable.Cell(1,1).Range.InlineShapes.AddPicture(strLogo)

objTable.Cell(1,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(1,2).Range.Font.Size = "10"
objTable.Cell(1,2).Range.Font.Bold = True
NameArray = Split(strName, " ", -1, 1)
objTable.Cell(1,2).Range.Text = NameArray(1)
objTable.Cell(2,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(2,2).Range.Font.Size = "10"
objTable.Cell(2,2).Range.Font.Bold = True
objTable.Cell(2,2).Range.Text = NameArray(0)


objTable.Cell(3,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(3,2).Range.Font.Size = "9"
objTable.Cell(3,2).Range.Text = strTitle


objTable.Cell(4,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(4,2).Range.Font.Size = "9"
objTable.Cell(4,2).Range.Text = "+7 (" & Mid(strMobile,2,3) & ") " & Mid(strMobile,5,3) &"-"& Mid(strMobile,8,2) &"-"& Right(strMobile,2)


objTable.Cell(5,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(5,2).Range.Font.Size = "9"
objTable.Cell(5,2).Range.Text = " "

objTable.Cell(6,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(6,2).Range.Font.Size = "9"
objTable.Cell(6,2).Range.Text = "Хибиногорский пер., 33,"

objTable.Cell(7,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(7,2).Range.Font.Size = "9"
objTable.Cell(7,2).Range.Text = "Екатеринбург, 620010"


tel7 = Right(strPhone,7)
If Not IsEmpty(tel7) Then
	objTable.Cell(8,2).Range.Font.Name = "WeblySleek UI Semibold"
	objTable.Cell(8,2).Range.Font.Size = "9"
	objTable.Cell(8,2).Range.Text = "+7 (343) " & Left(tel7,3) &"-"& Mid(tel7,4,2) &"-"& Right(tel7,2)
End If

objTable.Cell(9,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(9,2).Range.Font.Size = "9"
objTable.Cell(9,2).Range.Text = "www.uralhimmash.ru"

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Else
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


objDoc.Tables.Add objRange,8,8
Set objTable = objDoc.Tables(1)

objdoc.Paragraphs.SpaceAfter = 0

objTable.Cell(1,1).Merge objTable.Cell(2,1)
objTable.Cell(1,1).Merge objTable.Cell(3,1)
objTable.Cell(1,1).Merge objTable.Cell(4,1)
objTable.Cell(1,1).Merge objTable.Cell(5,1)
objTable.Cell(1,1).Merge objTable.Cell(6,1)
objTable.Cell(1,1).Merge objTable.Cell(7,1)
objTable.Cell(1,1).Merge objTable.Cell(8,1)

objtable.cell(1,1).width = 130

objTable.Cell(1,6).Merge objTable.Cell(1,8)
objTable.Cell(1,6).Merge objTable.Cell(1,7)
objTable.Cell(1,5).Merge objTable.Cell(1,6)
objTable.Cell(1,4).Merge objTable.Cell(1,5)
objTable.Cell(1,3).Merge objTable.Cell(1,4)
objTable.Cell(1,2).Merge objTable.Cell(1,3)

objTable.Cell(2,6).Merge objTable.Cell(2,8)
objTable.Cell(2,6).Merge objTable.Cell(2,7)
objTable.Cell(2,5).Merge objTable.Cell(2,6)
objTable.Cell(2,4).Merge objTable.Cell(2,5)
objTable.Cell(2,3).Merge objTable.Cell(2,4)
objTable.Cell(2,2).Merge objTable.Cell(2,3)

objTable.Cell(3,6).Merge objTable.Cell(3,8)
objTable.Cell(3,6).Merge objTable.Cell(3,7)
objTable.Cell(3,5).Merge objTable.Cell(3,6)
objTable.Cell(3,4).Merge objTable.Cell(3,5)
objTable.Cell(3,3).Merge objTable.Cell(3,4)
objTable.Cell(3,2).Merge objTable.Cell(3,3)

objTable.Cell(4,6).Merge objTable.Cell(4,8)
objTable.Cell(4,6).Merge objTable.Cell(4,7)
objTable.Cell(4,5).Merge objTable.Cell(4,6)
objTable.Cell(4,4).Merge objTable.Cell(4,5)
objTable.Cell(4,3).Merge objTable.Cell(4,4)
objTable.Cell(4,2).Merge objTable.Cell(4,3)

objTable.Cell(5,6).Merge objTable.Cell(5,8)
objTable.Cell(5,6).Merge objTable.Cell(5,7)
objTable.Cell(5,5).Merge objTable.Cell(5,6)
objTable.Cell(5,4).Merge objTable.Cell(5,5)
objTable.Cell(5,3).Merge objTable.Cell(5,4)
objTable.Cell(5,2).Merge objTable.Cell(5,3)

objTable.Cell(6,6).Merge objTable.Cell(6,8)
objTable.Cell(6,6).Merge objTable.Cell(6,7)
objTable.Cell(6,5).Merge objTable.Cell(6,6)
objTable.Cell(6,4).Merge objTable.Cell(6,5)
objTable.Cell(6,3).Merge objTable.Cell(6,4)
objTable.Cell(6,2).Merge objTable.Cell(6,3)

objTable.Cell(7,6).Merge objTable.Cell(7,8)
objTable.Cell(7,6).Merge objTable.Cell(7,7)
objTable.Cell(7,5).Merge objTable.Cell(7,6)
objTable.Cell(7,4).Merge objTable.Cell(7,5)
objTable.Cell(7,3).Merge objTable.Cell(7,4)
objTable.Cell(7,2).Merge objTable.Cell(7,3)

objTable.Cell(7,6).Merge objTable.Cell(8,8)
objTable.Cell(7,6).Merge objTable.Cell(8,7)
objTable.Cell(7,5).Merge objTable.Cell(8,6)
objTable.Cell(7,4).Merge objTable.Cell(8,5)
objTable.Cell(7,3).Merge objTable.Cell(8,4)
objTable.Cell(7,2).Merge objTable.Cell(8,3)



objTable.Cell(1,1).Range.ParagraphFormat.Alignment = wdAlignParagraphRight
objTable.Cell(1,1).Range.InlineShapes.AddPicture(strLogo)

objTable.Cell(1,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(1,2).Range.Font.Size = "10"
objTable.Cell(1,2).Range.Font.Bold = True
NameArray = Split(strName, " ", -1, 1)
objTable.Cell(1,2).Range.Text = NameArray(1)
objTable.Cell(2,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(2,2).Range.Font.Size = "10"
objTable.Cell(2,2).Range.Font.Bold = True
objTable.Cell(2,2).Range.Text = NameArray(0)


objTable.Cell(3,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(3,2).Range.Font.Size = "9"
objTable.Cell(3,2).Range.Text = strTitle


objTable.Cell(4,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(4,2).Range.Font.Size = "9"
objTable.Cell(4,2).Range.Text = " "

objTable.Cell(5,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(5,2).Range.Font.Size = "9"
objTable.Cell(5,2).Range.Text = "Хибиногорский пер., 33,"

objTable.Cell(6,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(6,2).Range.Font.Size = "9"
objTable.Cell(6,2).Range.Text = "Екатеринбург, 620010"


tel7 = Right(strPhone,7)
If Not IsEmpty(tel7) Then
	objTable.Cell(7,2).Range.Font.Name = "WeblySleek UI Semibold"
	objTable.Cell(7,2).Range.Font.Size = "9"
	objTable.Cell(7,2).Range.Text = "+7 (343) " & Left(tel7,3) &"-"& Mid(tel7,4,2) &"-"& Right(tel7,2)
End If

objTable.Cell(8,2).Range.Font.Name = "WeblySleek UI Semibold"
objTable.Cell(8,2).Range.Font.Size = "9"
objTable.Cell(8,2).Range.Text = "www.uralhimmash.ru"




End If

objWord.Visible = True

