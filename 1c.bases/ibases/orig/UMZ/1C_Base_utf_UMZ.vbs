
Option Explicit
Dim domainName,userName,groupName,ADSPath,grouplistD,FSO,WshShell,tf,st
Dim objUser,objGroup

Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject("WScript.Shell")
dim home
dim path
home = WshShell.ExpandEnvironmentStrings("%USERPROFILE%")
home =home & "\AppData\Roaming\1C\1CEStart\ibases.v8i"



userName = CreateObject("WScript.Network").UserName

domainName = "omzglobal.com"

Set st = CreateObject("ADODB.Stream")
st.Type=2
st.Open
st.Charset = "UTF-8"

groupName = "UMZ-1C ÌÂ ÔÂÂÔËÒ˚‚‡Ú¸ ·‡Á˚" 
If IsMember(domainName,userName,groupName) Then
	WScript.quit
End If

groupName = "UMZ-1C «”œ"
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1— «”œ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-umz:1741"";Ref=""zup"";")
	st.WriteText vbCrLf
	st.WriteText("ID=9fbe980b-5474-4f51-8e37-015f5a3e75fc")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=714")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UMZ-1— ”œœ" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1— ”œœ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-umz"";Ref=""upp"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3c546019-6221-4659-a7f5-dabc3db4d0ea")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1162")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UMZ-1C «”œ “ÂÒÚ" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1C «”œ “ÂÒÚÓ‚‡ˇ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-umz"";Ref=""zup_test"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6b4d0a62-6e2d-4f7b-8e06-c3b026cc4e5e")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=810")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UMZ-1C ”œœ “ÂÒÚ" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1— ”œœ “ÂÒÚ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-umz"";Ref=""upp_test"";")
	st.WriteText vbCrLf
	st.WriteText("ID=16a483c4-4431-48b6-8582-34b4086a9cb3")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=778")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UMZ-1— ”œœ 2012-2017" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1— ”œœ 2012-2017]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-umz"";Ref=""upp_old"";")
	st.WriteText vbCrLf
	st.WriteText("ID=7f8a78c5-5186-4b8d-9b17-efbc2196aaa2")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1076.66666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=131072")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If

st.SaveToFile home,2



WScript.quit
  
' *****************************************************
Function IsMember(domainName,userName,groupName)
   Set groupListD = CreateObject("Scripting.Dictionary")
   groupListD.CompareMode = 1
   ADSPath = domainName & "/" & userName
   Set objUser = GetObject("WinNT://" & ADSPath & ",user")
   For Each objGroup in objUser.Groups
      groupListD.Add objGroup.Name, "-"
   Next
   IsMember = CBool(groupListD.Exists(groupName))
End Function
' *****************************************************