# Remove folder in Scheduled Tasks

Удаление папок в Планировщике заданий

https://stackoverflow.com/a/56929373/6127481

## Запуск

GPO /.../ Immediate Task
+ program: `powershell`
+ arguments: `gc -Raw \\service\Soft\Scripts\remove-sch-folder.ps1 | iex`
