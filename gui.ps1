Add-Type -Assemblyname System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "������ �����"
$form.StartPosition = "CenterScreen"
$form.AutoSize = 1

$label = New-Object System.Windows.Forms.Label
$label.Text = "������!"
$label.Location = New-Object System.Drawing.Point 20,10
$form.Controls.Add($label)

$button = New-Object Windows.Forms.Button
$button.Text = "����� ����!"
$button.AutoSize = 1
$button.Location = New-Object System.Drawing.Point 20,40
$button.Add_Click({$label.Text='����?'})
$form.Controls.Add($button)

$form.ShowDialog()
