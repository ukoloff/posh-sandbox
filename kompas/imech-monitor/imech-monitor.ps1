#
# InterMech monitoring
#
$URL = 'http://imech:8995/'

$q = Invoke-WebRequest $URL -UseBasicParsing

$dom = New-Object -ComObject "HTMLFile"
$dom.IHTMLDocument2_write([System.Text.Encoding]::Default.GetString($q.Content))

$dom.all.tags('h2') | % innerText
