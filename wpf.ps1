# https://habr.com/ru/articles/138008/
# https://metanit.com/sharp/wpf/

Add-Type -Assembly PresentationFramework
function add($control, $children)
{
   $children | %{ $control.Children.Add($_)} | Out-Null
   $control
}
$w = New-Object System.Windows.Window -prop @{
    WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen;
    SizeToContent = [System.Windows.SizeToContent]::WidthAndHeight;
    Content = add (New-Object System.Windows.Controls.StackPanel -prop @{Margin=5}) @(        
        add (New-Object System.Windows.Controls.StackPanel -prop @{ 
                Margin=5;
                Orientation = [System.Windows.Controls.Orientation]::Horizontal}) @(
            New-Object System.Windows.Controls.Button -prop @{Content="�������� A"; }
            New-Object System.Windows.Controls.Button -prop @{Content="�������� �";}
        )
        New-Object System.Windows.Controls.TextBlock -prop @{Text="�����"}        
        New-Object System.Windows.Controls.Combobox -prop @{ItemsSource=@("����� 1", "����� 2"); IsEditable=0}
    );    
}
$w.ShowDialog()