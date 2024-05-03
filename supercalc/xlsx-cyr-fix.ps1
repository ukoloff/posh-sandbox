#
#  Поправить кодировку русских букв в файле .XLSX,
#  полученном из SuperCalc:
#   1. SuperCalc 4
#   2. Export 1-2-3, расщирение .wk1
#   3. Открыть в Gnumeric и сохранить в .xlsx
#   4. Натравить эту утилиту
#   5. Осмотреть и сохранить
#
using namespace System.Windows.Forms

Add-Type -AssemblyName System.Windows.Forms

$d = New-Object OpenFileDialog
$d.Title = "Выберите XLSX-файл для перекодировки русских букв"
$d.Filter = 'XSLX-файлы|*.xlsx|Все файлы|*.*'

if ($d.ShowDialog() -eq "OK") {
  $src = $d.FileName
}

# $src = 'C:\Users\s.ukolov\Documents\repo\posh-sandbox\supercalc\test\test.xlsx'

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
