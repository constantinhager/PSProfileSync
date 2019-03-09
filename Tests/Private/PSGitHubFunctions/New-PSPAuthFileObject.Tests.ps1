$ModuleManifestName = 'PSProfileSync.psd1'
$Root = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName
$ModuleManifestPath = Join-Path $Root -ChildPath "PSProfileSync\$ModuleManifestName"

if (Get-Module PSProfileSync)
{
    Remove-Module PSProfileSync
    Import-Module $ModuleManifestPath
}
else
{
    Import-Module $ModuleManifestPath
}

InModuleScope PSProfileSync {
    Context "New-PSPAuthFileObject" {

        $UserName = "testuser"
        $PatToken = "00000"
        $GistId = "3467834879589764235897"

        It "Method returns a PSCustomObject" {
            $return = New-PSPAuthFileObject -GistId $GistId -PATToken $PatToken -UserName $UserName
            $return | Should -BeOfType System.Management.Automation.PSCustomObject
        }
    }
}