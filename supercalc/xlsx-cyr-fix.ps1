#
#  Поправить кодировку русских букв в файле .XLSX,
#  полученном из SuperCalc:
#   1. SuperCalc 4
#   2. Export 1-2-3, расщирение .wk1
#   3. Открыть в Gnumeric и сохранить в .xlsx
#   4. Натравить эту утилиту
#   5. Осмотреть и сохранить
using namespace System.Windows.Forms

Add-Type -AssemblyName System.Windows.Forms

$d = New-Object OpenFileDialog
$d.Title = "Выберите XLSX-файл для перекодировки русских букв"
$d.Filter = 'XSLX-файлы|*.xlsx|Все файлы|*.*'

if ($d.ShowDialog() -eq "OK") {
  Write-Output $d.FileName
}

