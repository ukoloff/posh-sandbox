
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

groupName = "UZHM-1C не переписывать базы" 
If IsMember(domainName,userName,groupName) Then
	WScript.quit
End If


groupName = "UZHM-1C_ГЗХМ_Документооборот" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1С Документооборот]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh1"";Ref=""DOC_TEST"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10927018-0ff0-4c55-9351-08cbaf52a068")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=400")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=400")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=ThickClient")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If



groupName = "UZHM-1C_ГЗХМ_ЗУП" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C ЗУП старая]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""ZUP"";")
	st.WriteText vbCrLf
	st.WriteText("ID=a6ee32c0-b3b2-4dc0-8b8a-fc670d966159")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=100")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=100")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=ThickClient")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_ГЗХМ_ЗУП" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C ЗУП 3.20]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""SRV1C-EKBH3:1641"";Ref=""zup_20"";")
	st.WriteText vbCrLf
	st.WriteText("ID=e50a119b-f255-4d0f-b494-d90c9421428d")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=100")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=100")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=ThickClient")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_ГЗХМ_Оперативное планирование" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C Оперативное планирование]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""SRV1C-EKBH3:1641"";Ref=""OP_work"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=300")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=300")
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




groupName = "UZHM-1C_ГЗХМ_УПП" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C УПП]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh3:1641"";Ref=""ERP_Work"";")
	st.WriteText vbCrLf
	st.WriteText("ID=2a035f2b-d888-49f5-9c45-c59afb1b6482")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=200")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=200")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=ThickClient")
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
