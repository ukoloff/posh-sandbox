
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

groupName = "UZHM-1C_Капитал Химмаш"
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1C Капитал Химмаш]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh3:1641"";Ref=""EK_KH"";")
	st.WriteText vbCrLf
	st.WriteText("ID=ee5e02f9-5768-44de-b6af-65dd5dff9e14")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1375.33333333334")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=606208")
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


groupName = "UZHM-1C_ЗУП" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1C ЗУП]")
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
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86_64_prt")
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


groupName = "UZHM-1C_Оперативное планирование" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1C Оперативное планирование]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh3:1641"";Ref=""OP_WORK"";")
	st.WriteText vbCrLf
	st.WriteText("ID=8cdc3b35-5d09-421c-9f5e-2d0c6052f0b5")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1233.11111111111")
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
	st.WriteText("AppArch=x86_prt")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_УПП" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1C УПП]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh3:1641"";Ref=""ERP_WORK"";")
	st.WriteText vbCrLf
	st.WriteText("ID=f2258681-c026-401c-bb53-573d8d182cac")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1296.22222222222")
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
	st.WriteText("AppArch=x86_prt")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_УралРемСервис" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C УралРемСервис]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh3:1641"";Ref=""URALREMSERVICE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=a45d7763-0e3d-49a0-8b8c-499a9462ff72")
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
	st.WriteText("Connect=Srvr=""srv1c-ekbh3:1641"";Ref=""EK_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=10456975-1355-418b-a731-3c798de8e7e3")
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


groupName = "UZHM-1C АИС ПТР" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[АИС ПТР]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-spb5"";Ref=""aisptr"";")
	st.WriteText vbCrLf
	st.WriteText("ID=5eb93c31-15b1-4462-91ec-eb1fdff06bd8")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=5197.5")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=75731")
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


groupName = "UZHM-1C_ЗУП 3.20" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[1C ЗУП 3.20]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh3:1641"";Ref=""ZUP_20"";")
	st.WriteText vbCrLf
	st.WriteText("ID=aa2b8d13-9eb9-4603-ac5f-48cd758c14dd")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1268.96296296296")
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

groupName = "UZHM-1C_УПП Тестирование" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С УПП TEST2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""ERP_WORK_TEST2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=eb8eb118-be44-4047-966e-f87233a4c3e2")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=6623.33333333333")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=147856")
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

groupName = "UZHM-1C_УПП Тест5" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С УПП для теста Заявочной компании]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""ERP_WORK_TEST5"";")
	st.WriteText vbCrLf
	st.WriteText("ID=eb8eb118-be44-4047-966e-f87233a4c3e2")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=6623.33333333333")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=147856")
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

groupName = "UZHM-1C_МСФО 1 кв 2022" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2022]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_1_2022"";")
	st.WriteText vbCrLf
	st.WriteText("ID=9c092039-e21f-4bc4-a6ec-642cb6c27624")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=730")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=377232")
	st.WriteText vbCrLf
	st.WriteText("External=0")
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

groupName = "UZHM-1C_МСФО 1 кв 2022 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2022 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_1_2022_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6df9db1c-4774-4614-90e5-8ebf49591b27")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=718")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=393616")
	st.WriteText vbCrLf
	st.WriteText("External=0")
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

groupName = "UZHM-1C_МСФО 1 кв 2022 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2022 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_1_2022_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=1d7939b5-d387-44cc-b1f5-f43bd9527c6c")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=712")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
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

groupName = "UZHM-1C_МСФО 2 кв 2022 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2022 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_2_2022_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=bfeb1209-329e-468a-97e2-c6e9d1086757")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=600")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=524688")
	st.WriteText vbCrLf
	st.WriteText("External=0")
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

groupName = "UZHM-1C_МСФО 2 кв 2022 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2022 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_2_2022_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=96f4b504-be2a-46b4-81ce-c3cc757880c2")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=266.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=426384")
	st.WriteText vbCrLf
	st.WriteText("External=0")
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

groupName = "UZHM-1C_МСФО 2 кв 2022" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2022]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_2_2022"";")
	st.WriteText vbCrLf
	st.WriteText("ID=734a793f-dce2-41d2-b913-956962fb3546")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=800")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=442768")
	st.WriteText vbCrLf
	st.WriteText("External=0")
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


groupName = "UZHM-1C_МСФО 3 кв 2022" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 3 кв 2022]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2022"";")
	st.WriteText vbCrLf
	st.WriteText("ID=437c8c98-3d74-455d-abb2-c2e499bffbbd")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=16512")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=33024")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("DefaultVersion=8.3.15.1565")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_МСФО 3 кв 2022 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 3 кв 2022 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2022_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=4a589329-f8f0-4a76-81d9-d5c281634bda")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=17024")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86_prt")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 3 кв 2022 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 3 кв 2022 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_3_2022_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=f31d2c10-79de-49cf-95df-16e6c2b9f4c6")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=16768")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=49408")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("DefaultVersion=8.3.15.1565")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_МСФО 4 кв 2022" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 4 кв 2022]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_4_2022"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3e2462c3-4342-475d-a323-7ab71962be20")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=16810.6666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=180480")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86_64_prt")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 4 кв 2022 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 4 кв 2022 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_4_2022_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=a33a95b3-e423-4aa2-bee1-47961acdaddf")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=17066.6666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=196864")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86_64_prt")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 4 кв 2022 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 4 кв 2022 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2"";Ref=""MCFO_4_2022_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=a9a13e70-7b5b-417b-aba0-79bf6d0ac447")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=16938.6666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=213248")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86_64_prt")
	st.WriteText vbCrLf
End If



groupName = "UZHM-1C_ЗУП 3.20 Тест" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С ЗУП 20 Тест]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""ZUP_20_TEST"";")
	st.WriteText vbCrLf
	st.WriteText("ID=ba4cd3db-91c9-419b-84f4-d7c6ed5136c1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=16554.6666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=147712")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_УПП Обучение" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С УПП Обучение]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""ERP_WORK_TEST4"";")
	st.WriteText vbCrLf
	st.WriteText("ID=521cb77f-6c15-4817-8914-ac0a40ccea18")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=250")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=16684")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 1 кв 2023" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2023]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_1_2023"";")
	st.WriteText vbCrLf
	st.WriteText("ID=c2e2641d-d2cf-4694-bf9e-53438ad9c10d")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1226")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=65936")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 1 кв 2023 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2023 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_1_2023_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=ac16976e-d0cf-42f7-9b27-29b22301cee6")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1098")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=82320")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 1 кв 2023 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2023 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_1_2023_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=2dc6d1e4-aca2-48ca-9650-81ae9d1a4d50")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1034")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=98704")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_УПП_УК УЗХМ" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С УПП УК УЗХМ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""UK_UZXM"";")
	st.WriteText vbCrLf
	st.WriteText("ID=719f5302-ab73-41da-80a5-9f9e894829d9")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=970")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=49552")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1С_Бухгалтерия УК УЗХМ" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С Бухгалтерия УК УЗХМ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""BUH_UK_UZHM"";")
	st.WriteText vbCrLf
	st.WriteText("ID=c1b774ce-b1a6-4885-9fa0-9afe4bd04d75")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1146")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=131472")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_ЗУП УК_УЗХМ" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С ЗУП УК УЗХМ]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""ZUP_UK_UZHM"";")
	st.WriteText vbCrLf
	st.WriteText("ID=d33c4a69-816a-425d-a4e6-247330ffa666")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1066")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=115088")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 2 кв 2023" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2023]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_2_2023"";")
	st.WriteText vbCrLf
	st.WriteText("ID=90db9b30-3f18-4850-9795-93332c107eb1")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=394.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=131472")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 2 кв 2023 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2023 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_2_2023_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=8c307364-b8dc-47ee-8f0f-9050dad0ef43")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=330.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=147856")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If


groupName = "UZHM-1C_МСФО 2 кв 2023 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2023 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_2_2023_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=14b2cade-6b44-4314-b1e1-9c6366641033")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=298.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=164240")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 3 кв 2023" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 3 кв 2023]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_3_2023"";")
	st.WriteText vbCrLf
	st.WriteText("ID=b5c2e50e-b922-47f0-aebc-b1b34f23ec03")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=767.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=246160")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("DefaultVersion=8.3.22.2208")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 3 кв 2023 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 3 кв 2023 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_3_2023_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=16ba63c1-de96-4f14-a42c-680efd301fc2")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=639.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 3 кв 2023 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 3 кв 2023 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_3_2023_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=cfe2b51e-f754-49b2-96f4-45e804326713")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=511.666666666667")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=229776")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("DefaultVersion=8.3.22.2208")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_УПП Тест7" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С УПП для теста нового функционала]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""erp_work_test7"";")
	st.WriteText vbCrLf
	st.WriteText("ID=6251942d-8df9-4358-820d-6f4ee0aedd6c")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=447.833333333333")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 4 кв 2023 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 4 кв 2023 Химмаш Энерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_4_2023_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=8ca8cdcb-3aee-439b-bf33-7c4cfd455ba8")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1282.88888888889")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=245760")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("DefaultVersion=8.3.22.2239")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 4 кв 2023 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 4 кв 2023 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_4_2023_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=aa79cc0c-40c1-472c-90ac-38f5fe462a27")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1279.33333333334")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=229376")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("DefaultVersion=8.3.22.2239")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 4 кв 2023" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 4 кв 2023]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_4_2023"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3c62f83e-550a-4d8e-a5c1-4e4864210ee5")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1287.62962962963")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=278528")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 1 кв 2024" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2024]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_1_2024"";")
	st.WriteText vbCrLf
	st.WriteText("ID=47a55a1b-e850-4e39-8783-958b3ea5e44d")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1288.81481481482")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=409600")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 1 кв 2024 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 квартал 2024 ХиммашЭнерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_1_2024_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=bc02d43f-4efb-4c85-b483-7a6ca36a9b49")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1284.07407407408")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=425984")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 1 кв 2024 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 1 кв 2024 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_1_2024_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=73758205-3b25-4718-8dfb-704262b168de")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1281.70370370371")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=42368")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 2 кв 2024 Капитал Химмаш и ТПП2" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2024 Капитал Химмаш и ТПП2]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_2_2024_KH_TPP2"";")
	st.WriteText vbCrLf
	st.WriteText("ID=3fe73727-a874-49b8-bc0d-0db12b76e540")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1484.50000000001")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=557056")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 2 кв 2024 Химмаш Энерго" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 квартал 2024 ХиммашЭнерго]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_2_2024_HE"";")
	st.WriteText vbCrLf
	st.WriteText("ID=4a23fbe6-5247-4f05-8c82-1940292e9545")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1384.28703703704")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=573440")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 2 кв 2024" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 2 кв 2024]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_2_2024"";")
	st.WriteText vbCrLf
	st.WriteText("ID=0d89c38c-786f-4181-8b77-883731627e61")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1331.81018518519")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=589824")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 3 кв 2024" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 3 кв 2024]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_3_2024"";")
	st.WriteText vbCrLf
	st.WriteText("ID=ed4d95f7-0130-4c41-9997-d0bf1a002fb7")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1139.33333333334")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=737280")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_МСФО 4 кв 2024" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*МСФО 4 кв 2024]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""MCFO_4_2024"";")
	st.WriteText vbCrLf
	st.WriteText("ID=56ca1193-cdf1-451d-92d1-11e5d1924fe7")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1260.37037037037")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=901120")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
	st.WriteText vbCrLf
End If

groupName = "UZHM-1C_УПП Тест8" 
If IsMember(domainName,userName,groupName) Then
	st.WriteText("[*1С УПП Тест 8]")
	st.WriteText vbCrLf
	st.WriteText("Connect=Srvr=""srv1c-ekbh2:1641"";Ref=""ERP_WORK_TEST8"";")
	st.WriteText vbCrLf
	st.WriteText("ID=2b49aee4-590c-4318-af16-e17ed436ef56")
	st.WriteText vbCrLf
	st.WriteText("OrderInList=1234.00000000001")
	st.WriteText vbCrLf
	st.WriteText("Folder=/")
	st.WriteText vbCrLf
	st.WriteText("OrderInTree=-1")
	st.WriteText vbCrLf
	st.WriteText("External=0")
	st.WriteText vbCrLf
	st.WriteText("App=Auto")
	st.WriteText vbCrLf
	st.WriteText("WA=1")
	st.WriteText vbCrLf
	st.WriteText("Version=8.3")
	st.WriteText vbCrLf
	st.WriteText("AppArch=x86")
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