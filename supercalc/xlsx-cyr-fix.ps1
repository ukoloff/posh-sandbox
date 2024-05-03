#
#  Поправить кодировку русских букв в файле .XLSX,
#  полученном из SuperCalc:
#
using namespace System.Windows.Forms

Add-Type -AssemblyName System.Windows.Forms

Write-Output @"
Конвертация из SuperCalc .cal в Excel .xlsx
-------------------------------------------
1. Используйте SuperCalc 4
2. Откройте .cal-файл
3. Экспортируйте в 1-2-3 с расширением .wk1
4. Откройте в Gnumeric
5. Сохраните в .xslx
6. Выберите полученный файл для исправления русских букв
7. Просмотрите результат и сохраните, если надо

"@

$d = New-Object OpenFileDialog
$d.Title = "Выберите XLSX-файл для перекодировки русских букв"
$d.Filter = 'XSLX-файлы|*.xlsx|Все файлы|*.*'

if ($d.ShowDialog() -eq "OK") {
  $src = $d.FileName
}

$xls = New-Object -ComObject Excel.Application
$xls.visible = $true

$wb = $xls.Workbooks.Open($src)
$s = $wb.ActiveSheet

$i850 = [System.Text.Encoding]::GetEncoding('ibm850')
$cp866 = [System.Text.Encoding]::GetEncoding('cp866')

# https://stackoverflow.com/a/78318241/6127481
$r = $s.range($s.Cells(1, 1), $s.Cells.SpecialCells(11))  # 11 = xlCellTypeLastCell

$i = 0
foreach ($c in $r) {
  if ($xls.WorksheetFunction.IsText($c)) {
    $i += 1
    Write-Host -NoNewline "`rПерекодируем ячейку $i"
    $c.value = $cp866.GetString($i850.GetBytes($c.Text))
  }
}

Write-Output "`nНажмите любую клавищу для завершения..."
[Console]::ReadKey(1) | Out-Null
