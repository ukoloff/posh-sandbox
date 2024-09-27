# TSG-LOG

Сбор событий входа / выхода на шлюзе терминалов

## Фильтр событий
По пользователю:
```xml
<QueryList>
  <Query Id="0" Path="Microsoft-Windows-TerminalServices-Gateway/Operational">
    <Select Path="Microsoft-Windows-TerminalServices-Gateway/Operational">*[System[(EventID=302 or EventID=303)]] and*[UserData[EventInfo[Username="OMZGLOBAL\1c_sovetnik"]]]</Select>
  </Query>
</QueryList>
```
