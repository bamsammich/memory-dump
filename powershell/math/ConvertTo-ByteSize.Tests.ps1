. "$PSScriptRoot\ConvertTo-ByteSize.ps1"


Describe 'ConvertTo-ByteSize' {

  It "Given -Size '<Filter>', it returns '<Expected>'" -TestCases @(
    @{'Filter' = '1KB'; 'Expected' = 1000 },
    @{'Filter' = '1KiB'; 'Expected' = 1024 },
    @{'Filter' = '1 KiB'; 'Expected' = 1024 },
    @{'Filter' = '1B'; 'Expected' = 1 },
    @{'Filter' = '1TB'; 'Expected' = [System.Math]::Pow(1000, 4) },
    @{'Filter' = '1TiB'; 'Expected' = [System.Math]::Pow(1024, 4) }
  ) {
    param ($Filter, $Expected)

    $size = ConvertTo-ByteSize -Size $Filter
    $size | Should -Be $Expected
  }
}