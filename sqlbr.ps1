Add-Type -assembly System.Windows.Forms

function winMain() {
    $w = New-Object System.Windows.Forms.Form
    $gb = New-Object System.Windows.Forms.GroupBox
    $rbB = New-Object System.Windows.Forms.RadioButton
    $rbR = New-Object System.Windows.Forms.RadioButton
    $dbLabel = New-Object System.Windows.Forms.Label
    $db = New-Object System.Windows.Forms.ComboBox

    $w.StartPosition = "CenterScreen"
    $w.Text = "Backup / Restore MS SQL database"
    $w.AutoSize = 1

    $gb.Text = 'Action'
    $gb.Location = New-Object System.Drawing.Point(5, 5)
    $gb.Size = New-Object System.Drawing.Point(150, 10)
    $gb.AutoSize = 1

    $rbB.Location = New-Object System.Drawing.Point(10, 15)
    $rbB.Text = 'Backup'
    $rbB.AutoSize = 1
    $rbB.Checked = 1
    $rbR.Location = New-Object System.Drawing.Point($rbB.Right, 15)
    $rbR.Text = 'Restore'
    $rbR.AutoSize = 1

    $dbLabel.Location = New-Object System.Drawing.Point(5, 65)
    $dbLabel.Text = '&Database'
    $dbLabel.UseMnemonic = 1

    $db.Location = New-Object System.Drawing.Point(5, 90)
    $db.AutoSize = 1
    # $db.Width = 100
    $db.DataSource = @("One", "Two", "Three")
    # $db.TabStop=1
    
    $gb.Controls.Add($rbB)
    $gb.Controls.Add($rbR)
    $w.Controls.Add($gb)
    $w.Controls.Add($dbLabel)
    $w.Controls.Add($db)

    return $w
}

$w = winMain
$w.ShowDialog()
