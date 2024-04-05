# https://habr.com/ru/articles/138008/
# https://metanit.com/sharp/wpf/
using namespace System.Windows
using namespace System.Windows.Controls

Add-Type -Assembly PresentationFramework
function add($control, $children)
{
   $children | %{ $control.Children.Add($_)} | Out-Null
   $control
}
$w = New-Object Window -prop @{
    WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen;
    SizeToContent = [System.Windows.SizeToContent]::WidthAndHeight;
    Content = add (New-Object StackPanel -prop @{Margin=5}) @(        
        add (New-Object StackPanel -prop @{ 
                Margin=5;
                Orientation = [Orientation]::Horizontal}) @(
            New-Object Button -prop @{Content="�������� A"; }
            New-Object Button -prop @{Content="�������� �";}
        )
        New-Object TextBlock -prop @{Text="�����"}        
        New-Object Combobox -prop @{ItemsSource=@("����� 1", "����� 2"); IsEditable=1}
    );    
}
$w.ShowDialog()