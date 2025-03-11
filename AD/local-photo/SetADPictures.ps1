Function ResizeImage {
    Param (
    [Parameter(Mandatory = $True, HelpMessage = "image in byte")]
    [ValidateNotNull()]
    $imageSource,
    [Parameter(Mandatory = $true, HelpMessage = "Параметр размер должен быть от 16 до 1000")]
    [ValidateRange(16, 1000)]
    $canvasSize,
    [Parameter(Mandatory = $true, HelpMessage = "Параметр качества должен быть от 1 до 100")]
    [ValidateRange(1, 100)]
    $ImgQuality = 100
    )
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $imageBytes = [byte[]]$imageSource
    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
    $ms.Write($imageBytes, 0, $imageBytes.Length);
    $bmp = [System.Drawing.Image]::FromStream($ms, $true)
    # Размер картинки после конвертации
    $canvasWidth = $canvasSize
    $canvasHeight = $canvasSize
    # Задание качества картинки
    $myEncoder = [System.Drawing.Imaging.Encoder]::Quality
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($myEncoder, $ImgQuality)
    #Получаем тип картинки
    $myImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    # Высчитывание кратности
    $ratioX = $canvasWidth / $bmp.Width;
    $ratioY = $canvasHeight / $bmp.Height;
    $ratio = $ratioY
    if ($ratioX -le $ratioY) {
    $ratio = $ratioX
    }
    # Создание пустой картинки
    $newWidth = [int] ($bmp.Width * $ratio)
    $newHeight = [int] ($bmp.Height * $ratio)
    $bmpResized = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
    $graph = [System.Drawing.Graphics]::FromImage($bmpResized)
    $graph.Clear([System.Drawing.Color]::White)
    $graph.DrawImage($bmp, 0, 0 , $newWidth, $newHeight)
    # Создание пустого потока
    $ms = New-Object IO.MemoryStream
    $bmpResized.Save($ms, $myImageCodecInfo, $($encoderParams))
    # уборка
    $bmpResized.Dispose()
    $bmp.Dispose()
    return $ms.ToArray()
    }
    $ADUserInfo = ([ADSISearcher]"(&(objectCategory=User)(SAMAccountName=$env:username))").FindOne().Properties
    $ADUserInfo_sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    If ($ADUserInfo.thumbnailphoto) {
    $img_sizes = @(32, 40, 48, 96, 192, 200, 240, 448)
    $img_base = "C:\Users\Public\AccountPictures"
    $reg_key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AccountPicture\Users\$ADUserInfo_sid"
    If ((Test-Path -Path $reg_key) -eq $false) { New-Item -Path $reg_key } { write-verbose "Reg key exist [$reg_key]" }
    Try {
    ForEach ($size in $img_sizes) {
    $dir = $img_base + "\" + $ADUserInfo_sid
    If ((Test-Path -Path $dir) -eq $false) { $(New-Item -ItemType directory -Path $dir).Attributes = "Hidden" }
    $file_name = "Image$($size).jpg"
    $path = $dir + "\" + $file_name
    Write-Verbose " Crete file: [$file_name]"
    try {
    ResizeImage -imageSource $($ADUserInfo.thumbnailphoto) -canvasSize $size -ImgQuality 100 | Set-Content -Path $path -Encoding Byte -Force -ErrorAction Stop
    Write-Verbose " File saved: [$file_name]"
    }
    catch {
    If (Test-Path -Path $path) {
    Write-Warning "File exist [$path]"
    }
    else {
    Write-Warning "File not exist [$path]"
    }
    }
    $name = "Image$size"
    try {
    $null = New-ItemProperty -Path $reg_key -Name $name -Value $path -Force -ErrorAction Stop
    }
    catch {
    Write-Warning "Reg key edit error [$reg_key] [$name]"
    }
    }
    }
    Catch {
    Write-Error "Check permissions to files or registry."
    }
    }