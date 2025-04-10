
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

groupName = "UZHM-1C_SISMMK" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1С АС SISMMK]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""SISMMK_test"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10927018-0ff0-4c55-9351-08cbaf52a169")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=500")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=500")
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

groupName = "UZHM-1C_Документооборот" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1С Документооборот]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""DOC_TEST"";")
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
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_ДСЕ" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C ДСЕ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""SrvDSE-ekbh1"";Ref=""DSE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=8eec95ef-c14d-48e4-9e42-9ef2d4431e9e")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=500")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=500")
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



groupName = "UZHM-1C_ЗУП" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C ЗУП]")
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



groupName = "UZHM-1C_Капитал Химмаш" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C Капитал Химмаш]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""EK_KH"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1000")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=1000")
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



groupName = "UZHM-1C_Метрология" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1С Метрология]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""metrology"";")
	st.WriteText vbCrLf
	st.WriteText("ID=ee734c71-6781-4705-9bea-79b01ffb34bc")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=506")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=49552")
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


groupName = "UZHM-1C_МСФО 1 кв 2016" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2016]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_1_2016"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20161")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20161")
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


groupName = "UZHM-1C_МСФО 1 кв 2017" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2017]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_1_2017"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20171")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20171")
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


groupName = "UZHM-1C_МСФО 1 кв 2018" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2018]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_1_2018"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20181")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20181")
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


groupName = "UZHM-1C_МСФО 1 кв 2019" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2019]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_1_2019"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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


groupName = "UZHM-1C_МСФО 1 кв 2019 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2019 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1cbit:1641"";Ref=""MCFO_1_2019_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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




groupName = "UZHM-1C_МСФО 1 кв 2019 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2019 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1cbit:1641"";Ref=""MCFO_1_2019_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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



groupName = "UZHM-1C_МСФО 1 кв 2020" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2020]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_1_2020"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3ff34b1d-aa28-44ee-bbd6-f7fe332660fa")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=10195")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=10195")
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


groupName = "UZHM-1C_МСФО 1 кв 2020  Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2020 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_1_2020_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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
'	st.WriteText("AppArch=x86_prt")
'	st.WriteText vbCrLf
End If



groupName = "UZHM-1C_МСФО 1 кв 2020 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 1 кв 2020 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_1_2020_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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





groupName = "UZHM-1C_МСФО 2 кв 2015" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2015]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_2_2015"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20152")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20152")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("ClientConnectionSpeed=Normal")
	st.WriteText vbCrLf
	st.WriteText("App=ThickClient")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.2")
	st.WriteText vbCrLf
End If




groupName = "UZHM-1C_МСФО 2 кв 2016" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2016]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_2_2016"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20162")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20162")
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




groupName = "UZHM-1C_МСФО 2 кв 2017" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2017]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_2_2017"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20172")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20172")
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




groupName = "UZHM-1C_МСФО 2 кв 2018" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2018]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_2_2018"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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




groupName = "UZHM-1C_МСФО 2 кв 2018 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2018 2 кв Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1cbit:1641"";Ref=""MCFO_2_2018_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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



groupName = "UZHM-1C_МСФО 2 кв 2018 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2018 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1cbit:1641"";Ref=""MCFO_2_2018_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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




groupName = "UZHM-1C_МСФО 2 кв 2019" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2019]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_2_2019"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3ff34b1d-aa28-44ee-bbd6-f7fe112660fa")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=10194")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=10194")
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



groupName = "UZHM-1C_МСФО 2 кв 2019 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2019 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1cbit:1641"";Ref=""MCFO_2_2019_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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




groupName = "UZHM-1C_МСФО 2 кв 2020" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2020]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_2_2020"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3ff34b1d-aa28-44ee-bbd6-f7fe332660fa")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=10195")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=10195")
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




groupName = "UZHM-1C_МСФО 2 кв 2020 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2020 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_2_2020_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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




groupName = "UZHM-1C_МСФО 2 кв 2020 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 2 кв 2020 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_2_2020_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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



groupName = "UZHM-1C_МСФО 3 кв 2015" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2015]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_3_2015"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20153")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20153")
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




groupName = "UZHM-1C_МСФО 3 кв 2016" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2016]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_3_2016"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20163")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20163")
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




groupName = "UZHM-1C_МСФО 3 кв 2017" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2017]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_3_2017"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20173")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20173")
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




groupName = "UZHM-1C_МСФО 3 кв 2019" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2019]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2019"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3ff34b1d-aa28-44ee-bbd6-f7fe332660fa")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=10195")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=10195")
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




groupName = "UZHM-1C_МСФО 3 кв 2019 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2019 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1cbit:1641"";Ref=""MCFO_3_2019_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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




groupName = "UZHM-1C_МСФО 3 кв 2019 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2019 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""SRV1C-EKBH2"";Ref=""MCFO_3_2019_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=d7233e0b-96c3-4c27-acb9-393f4e2df3e2")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=266.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=65936")
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



groupName = "UZHM-1C_МСФО 3 кв 2020" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2020]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2020"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3ff34b1d-aa28-44ee-bbd6-f7fe332660fa")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=10195")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=10195")
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




groupName = "UZHM-1C_МСФО 3 кв 2020 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2020 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2020_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=93ef3a72-e6a1-42de-a37f-8c8809c3b5b0")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=18514.8333333334")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
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


groupName = "UZHM-1C_МСФО 3 кв 2019 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2019 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""SRV1C-EKBH2"";Ref=""MCFO_3_2019_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=d7233e0b-96c3-4c27-acb9-393f4e2df3e2")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=266.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=65936")
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



groupName = "UZHM-1C_МСФО 3 кв 2020" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2020]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2020"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3ff34b1d-aa28-44ee-bbd6-f7fe332660fa")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=10195")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=10195")
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


groupName = "UZHM-1C_МСФО 3 кв 2020 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2020 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2020_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=93ef3a72-e6a1-42de-a37f-8c8809c3b5b0")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=18514.8333333334")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
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





groupName = "UZHM-1C_МСФО 3 кв 2020 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 3 кв 2020 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2020_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=2bc498ae-ba33-49ca-9e2e-ce973a3226de")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=44758")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=102102")
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






groupName = "UZHM-1C_МСФО 4 кв 2015" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 4 кв 2015]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_4_2015"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20154")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20154")
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




groupName = "UZHM-1C_МСФО 4 кв 2016" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 4 кв 2016]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_4_2016"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20164")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20164")
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



groupName = "UZHM-1C_МСФО 4 кв 2017" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 4 кв 2017]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_4_2017"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db917")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20174")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20174")
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



groupName = "UZHM-1C_МСФО 4 кв 2018" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 4 кв 2018]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""1C"";Ref=""MCFO_4_2018"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6602ea6b-4408-4636-a7b6-ffdfe62db919")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20174")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20174")
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



groupName = "UZHM-1C_МСФО 4 кв 2019" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 4 кв 2019]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_4_2019"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3ff34b1d-aa28-44ee-bbd6-f7fe332660fa")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=10195")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=10195")
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



groupName = "UZHM-1C_МСФО 4 кв 2019 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 4 кв 2019 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_4_2019_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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



groupName = "UZHM-1C_МСФО 4 кв 2019 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[МСФО 4 кв 2019 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_4_2019_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=20182")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=20182")
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
'	st.WriteText("AppArch=x86_prt")
'	st.WriteText vbCrLf
End If



groupName = "UZHM-1C_Оперативное планирование" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C Оперативное планирование]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""OP_WORK"";")
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



groupName = "UZHM-1C_УПП" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C УПП]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""ERP_WORK"";")
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
	st.WriteText("AppArch=x86_prt")
	st.WriteText vbCrLf
End If



groupName = "UZHM-1C_УралРемСервис" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C УралРемСервис]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""URALREMSERVICE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=a45d7763-0e3d-49a0-8b8c-499a9462ff71")
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



groupName = "UZHM-1C_Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""EK_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1100")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=1100")
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


groupName = "UZHM-1C УПП 2013" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C УПП 2013]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""work"";")
	st.WriteText vbCrLf
'	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e4")
'	st.WriteText vbCrLf
	st.WriteText("OrderInList=1100")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=1100")
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


groupName = "UZHM-1C_Портал поставщика" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[Портал поставщика]")
	st.WriteText vbCrLf
	st.WriteText("Connect=ws=""http://emm.niaep.ru/portal"";")
	st.WriteText vbCrLf
	st.WriteText("ID=bb05cdd5-a674-4cdc-b6b6-627c3764f037")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=456")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("UseProxy=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("WSA=0")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_ЗУП тестовая на данные на 09.12" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[ЗУП тестовая на данные на 09.12]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""ZUP3"";")
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
