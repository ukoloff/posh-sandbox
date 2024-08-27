#
# Удаление файлов старше ... дней в Корзину
#
$days = 180
$folder = 'c:\temp\x'

Add-Type -AssemblyName Microsoft.VisualBasic
function move2trash($path) {
  # https://stackoverflow.com/a/33981651/6127481
  if (Test-Path -Path $path -PathType Container) {
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($path, 'OnlyErrorDialogs', 'SendToRecycleBin')
  }
  else {
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($path, 'OnlyErrorDialogs', 'SendToRecycleBin')
  }
}

Get-ChildItem -Path $folder -File |
ForEach-Object {
  move2trash($_.FullName)
}
