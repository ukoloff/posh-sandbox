$a = Get-Content 'PaperCut/a.txt'

$b = [System.IO.File]::ReadAllLines('PaperCut/a.txt')

echo "That's all folks!"
