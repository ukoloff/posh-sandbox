#
# InterMech monitoring
#
$URL = 'http://imech:8995/'

$q = Invoke-WebRequest $URL

$dom = New-Object -ComObject "HTMLFile"
$dom.IHTMLDocument2_write([System.Text.Encoding]::Default.GetString($q.Content))

$out = [PSCustomObject]@{
  key   = $null
  date = $null
  days = $null
  count = $null
}

$dom.all.tags('h2') |
% innerText |
% {
  switch -Regex ($_) {
    ':\s*(?<Key>\d+)\s*$' {
      $out.key = $Matches.Key
    }
    '\s+(?<D>\d{1,2})([-./])(?<M>\d{1,2})\1(?<Y>\d{2,4})' {
      $out.date = "$($Matches.Y)-$($Matches.M)-$($Matches.D)"
      $out.days = ((Get-Date $out.date) - (Get-Date)).Days
    }
    '\s*(?<Sessions>\d+)\s+.*TCP/IP' {
      $out.count = [int]$Matches.Sessions
    }
  }
}

$out | ConvertTo-Json
