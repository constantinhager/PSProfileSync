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
    Context "Measure-PSPFreeSpaceOnSystemDrive" {
        It "Returns a uint64" {
            Mock -CommandName "Get-Volume" -MockWith {
                return 402993303552
            }

            $retval = Measure-PSPFreeSpaceOnSystemDrive

            $retval | Should -BeOfType System.uint64
            Assert-MockCalled -CommandName Get-Volume -Exactly 1
        }
    }
}