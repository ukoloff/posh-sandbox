# Копирование журналов резервных копий между SQL-серверами

Журналы резервных копий хранятся в БД `msdb`.

Копируем их на другой SQL-сервер,
чтобы иметь возможность раскатывать на нём
резервные копии штатными средствами `SQL Server Management Studio`.

```mermaid
erDiagram
backupfile {
  int backup_set_id FK
  int file_number PK
  int file_size
  string logical_name
  string physical_name
}
backupfilegroup {
  int backup_set_id FK
  int filegroup_id PK
}
backupset {
  int backup_set_id PK
  guid backup_set_uuid
  int media_set_id FK
  string name
  string user_name
  string database_name
}
backupmediaset {
  int media_set_id PK
  guid media_uuid
}
backupmediafamily {
  int media_set_id FK
  int family_sequence_number PK
  int mirror PK
  string physical_device_name
}
backupset ||--|| backupfilegroup : ""
backupset ||--|{ backupfile : "Содержит файлы БД"
backupset ||--|| backupmediaset : "Хранится в файлах на диске"
backupmediaset ||--|| backupmediafamily : "Содержит файл(ы)"
```

## Prerequisites

- Установите модуль `SimplySql`
- Дать права пользователю `System` на SQL
    + `msdb`/`db_datareader` на источнике
    + `sysadmin` на приёмнике
- Создать задание
    ```powershell
    .\bak-replica.ps1 -install
    ```
