-- Поиск в колонках id
DECLARE @search VARCHAR(100), @table SYSNAME, @column SYSNAME

DECLARE curTabCol CURSOR FOR
    SELECT c.TABLE_SCHEMA + '.' + c.TABLE_NAME, c.COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS c
    JOIN INFORMATION_SCHEMA.TABLES t
      ON t.TABLE_NAME=c.TABLE_NAME AND t.TABLE_TYPE='BASE TABLE' -- avoid views
    WHERE --c.DATA_TYPE IN ('varchar','nvarchar', 'char', 'nchar') -- searching only in these column types
     c.COLUMN_NAME like '_IDRRef' -- searching only in these column names


SET @search='0x80D100155D13885F11E873A6181004C0'

OPEN curTabCol
FETCH NEXT FROM curTabCol INTO @table, @column

WHILE (@@FETCH_STATUS = 0)
BEGIN
    EXECUTE('IF EXISTS
             (SELECT * FROM ' + @table + ' WHERE ' + @column + ' = ' + @search + ')
             PRINT ''' + @table + '.' + @column + '''')
    FETCH NEXT FROM curTabCol INTO @table, @column
END

CLOSE curTabCol
DEALLOCATE curTabCol

