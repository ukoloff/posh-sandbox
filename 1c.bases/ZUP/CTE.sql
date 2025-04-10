with
fiz as(
-- Справочник.ФизическиеЛица	_Reference562
Select
  _IDRRef As id,
  _Code As tabNo,
  _Description As FIO,
  DATEADD(YYYY, -2000, Cast(_Fld41457 As date)) as bdate,
  _Fld41458RRef	As sex_ref,		-- _Enum1046
  _Fld41459	As INN,
  _Fld41460	As SNILS,
  DATEADD(YYYY, -2000, Cast(_Fld41467 As date)) as regdate,
  _Fld41471	As F,
  _Fld41472	As I,
  _Fld41473	As O
From _Reference562X1
),
rab as(
-- Справочник.Сотрудники	_Reference458
Select
  _IDRRef As id,
  _Code As tabNo,
  _Description As FIO,
  _Fld39756RRef	As fiz_id,		-- _Reference562
  _Fld39757RRef	As morg_id,		-- _Reference265
  _Fld39761RRef	As mrab_id,		-- _Reference458
  _Fld45806	As [user]
From _Reference458
),
org as(
-- Справочник.Организации	_Reference265
Select
  _IDRRef As id,
  _Description As nickname,
  _Fld34752	As longname,
  _Fld34753	As shortname
From _Reference265
),
dept as(
-- Справочник.ПодразделенияОрганизаций	_Reference347
Select
  _IDRRef As id,
  _Code As Kod,
  _Description As name,
  _OwnerIDRRef As org_id,		-- _Reference265
  _ParentIDRRef	As up_id,		-- _Reference347
  _Fld37105RRef	As morg_id 		-- _Reference265
From _Reference347X1
),
hist as(
-- РегистрСведений.КадроваяИсторияСотрудников	_InfoRg22039
Select
  DATEADD(YYYY, -2000, _Period) as ctime,
  _Fld22052 As isKey,
  _Fld22047 As Wage,
  _Fld22040RRef As rab_id,		-- _Reference458
  _Fld22041RRef As morg_id,		-- _Reference265
  _Fld22042RRef As fiz_id,		-- _Reference562
  _Fld22043RRef As org_id,		-- _Reference265
  _Fld22044RRef As dept_id,		-- _Reference347
  _Fld22045RRef As pos_id,		-- _Reference137
  _Fld22046RRef As staff_id,	        -- _Reference576
  _Fld22048RRef As event_id,	        -- _Enum893
  _Fld22051RRef As mrab_id,		-- _Reference458
  _Fld22049RRef As agrm_id		-- _Enum880
From _InfoRg22039 As X
Where
  _Period=
  (Select Max(_Period)
  From _InfoRg22039 As Y
  Where Y._Fld22040RRef=X._Fld22040RRef)
),
tit as(
-- Справочник.Должности				_Reference137
Select
  _IDRRef As id,
  _Description As name
From _Reference137
),
stf as (
-- Справочник.ШтатноеРасписание			_Reference576
Select
  _IDRRef As id,
  _Description As name
From _Reference576
),
evnt as(
-- Перечисление.ВидыКадровыхСобытий		_Enum893
Select
  _IDRRef As id,
  _EnumOrder As value
From _Enum893
),
agmt as (
-- Перечисление.ВидыДоговоровССотрудниками		_Enum880
Select
  _IDRRef As id,
  _EnumOrder As value
From _Enum880
),
sex as(
-- Перечисление.ПолФизическогоЛица			_Enum1046
Select
  _IDRRef As id,
  _EnumOrder As [value]
From _Enum1046
),
psp as(
-- РегистрСведений.ДокументыФизическихЛиц	_InfoRg20909
Select
    _Fld20910RRef as fiz_id,
    _Fld20912 As Series,
    _Fld20913 As Number,
    DATEADD(YYYY, -2000, Cast(_Fld20914 As date)) as cdate,
    _Fld20916 As Issuer,
    _Fld20917 As iCode,
    _Fld20919 As Summary
From _InfoRg20909
Where
    _Fld20917 != ''
),
otdel as(
-- Справочник.СтруктураПредприятия	_Reference480
select
  _IDRRef As id,
  _Code As Kod,
  _Description As name,
  _ParentIDRRef As up_id,	-- self: _Reference480
  _Fld40083_RRRef As dept_id, -- _Reference347X1
  _Fld45826 As dept_kod
from _Reference480
),
layerD(up, dn) as(
  select
    U.id,
    D.id
  from
    dept U
    join dept D on U.id = D.up_id
),
treeD(up, dn, h) as(
  select
    up,
    dn,
    1
  from
    layerD
  union all
  select
    L.up,
    R.dn,
    L.h + 1
  from
    treeD as L
    join layerD as R on L.dn = R.up
)
select
  *
from
  treeD
order by
  h
