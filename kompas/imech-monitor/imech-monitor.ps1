#
# InterMech monitoring
#
$URL = 'http://imech:8995/'

$q = Invoke-WebRequest $URL -UseBasicParsing

$dom = New-Object -ComObject "HTMLFile"
$dom.IHTMLDocument2_write([System.Text.Encoding]::Default.GetString($q.Content))

$dom.all.tags('h2') |
% innerText |
% {
  switch -Regex ($_) {
    ':\s*(?<Key>\d+)\s*$' {
      "Key $($Matches.Key)"
    }
    '\s+(?<D>\d{1,2})([-./])(?<M>\d{1,2})\1(?<Y>\d{2,4})' {
      "Date $($Matches.Y)-$($Matches.M)-$($Matches.D)"
    }
    '\s*(?<Sessions>\d+)\s+.*TCP/IP' {
      "Sessions $($Matches.Sessions)"
    }
  }
}
