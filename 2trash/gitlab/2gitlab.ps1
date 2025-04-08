#
# Mirror repos to GitLab
#
Set-Location (Split-Path $PSCommandPath -Parent)
$root = git rev-parse --show-toplevel
$repos = Split-Path $root -Parent
$repos = Get-ChildItem -Path $repos -Directory

foreach ($repo in $repos) {
  "[$($repo)]"

  Set-Location $repo.FullName
  if ('gitlab' -notin (git remote)) {
    continue
  }
  git push --all gitlab
}
