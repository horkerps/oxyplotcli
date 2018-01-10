Set-StrictMode -Version 3

Import-Module $PSScriptRoot\..\OxyPlotCli -Force

$data = (
  [pscustomobject]@{ A = 1.5; B = -3 },
  [pscustomobject]@{ A = 2;   B = -2 },
  [pscustomobject]@{ A = 3;   B = -1.5 }
)

$dataA = 1.5, 2, 3
$dataB = -3, -2, -1.5
$dataSize = 10, 20, 30
$dataLabel = "foo", "bar", "baz"

Describe "New-OxyLineSeries" {

  BeforeEach {
    $s = $data | New-OxyLineSeries -XName A -YName B
  }

  It "takes a series of points through pipeline" {
    $s | Should -BeOfType [OxyPlot.Series.LineSeries]
    $s.Points.Count | Should -Be 3
    $s.Points[0].X | Should -Be 1.5
    $s.Points[2].Y | Should -Be -1.5
  }

  It "takes a series of points by parameters" {
    $s2 = New-OxyLineSeries -X $dataA -Y $dataB
    $s2.Points | Should -Be $s.Points
  }

  It "takes a series of points by parameters (-Data)" {
    $s2 = New-OxyLineSeries -XName A -YName B -Data $data
    $s2.Points | Should -Be $s.Points
  }

  It "accepts object properties as parameters" {
    $s2 = New-OxyLineSeries -X $dataA -Y $dataB -Smooth $true -LineStyle dash
    $s2.Smooth | Should -Be $true
    $s2.LineStyle | Should -Be "dash"
  }
}

Describe "OxyColor parameter" {

  It "accepts a color name" {
    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color white
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#ffffff"))

    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color transparent
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#00ffffff"))

    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color RED
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#ff0000"))
  }

  It "accepts in a hexadecimal style" {
    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color "#8090a0"
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#8090a0"))

    $s = New-OxyLineSeries -X $dataA -Y $dataB -Color 8090a0
    $s.Color | Should -Be ([OxyPlot.OxyColor]::Parse("#8090a0"))
  }

  It "raises an error for invalid parameter" {
    { $s = New-OxyLineSeries -X $dataA -Y $dataB -Color xxxx } | Should -Throw "Cannot validate"
  }
}

Describe "series creation cmdlets" {

  It "can create a AreaSeries object" {
    $s = New-OxyAreaSeries -X 1,2 -Y 3,4 -X2 5,6 -Y2 7,8
    $s | Should -BeOfType [OxyPlot.Series.AreaSeries]
    $s.Points[0].X | Should -Be 1
    $s.Points2[1].Y | Should -Be 8
  }

  It "can create a BarSeries object" {
    $s = New-OxyBarSeries -Value 1,2 -CategoryIndex 3,4
    $s | Should -BeOfType [OxyPlot.Series.BarSeries]
    $s.Items[0].Value | Should -Be 1
    $s.Items[1].CategoryIndex | Should -Be 4
  }

  It "can create a BoxPlotSeries object" {
    $s = New-OxyBoxPlotSeries `
      -X 1,2,3,4,5,6 `
      -LowerWhisker 11,12,13,14,15,16 `
      -BoxBottom 21,22,23,24,25,36 `
      -Median 31,32,33,34,35,36 `
      -BoxTop 41,42,43,44,45,46 `
      -UpperWhisker 51,52,53,54,55,56
    $s | Should -BeOfType [OxyPlot.Series.BoxPlotSeries]
    $s.Items[0].X | Should -Be 1
    $s.Items[1].LowerWhisker | Should -Be 12
    $s.Items[2].BoxBottom | Should -Be 23
    $s.Items[3].Median | Should -Be 34
    $s.Items[4].BoxTop | Should -Be 45
    $s.Items[5].UpperWhisker | Should -Be 56
  }

  It "can create a CandleStickAndVolumeSeries object" {
    $s = New-OxyCandleStickAndVolumeSeries `
      -X 1,2,3,4,5,6 `
      -Open 11,12,16,16,16,16 `
      -High 21,22,23,24,25,26 `
      -Low 31,32,33,34,35,36 `
      -Close 41,42,43,44,45,46 `
      -BuyVolume 51,52,53,54,55,56 `
      -SellVolume 61,62,63,64,65,66
    $s | Should -BeOfType [OxyPlot.Series.CandleStickAndVolumeSeries]
    $s.Items[0].X | Should -Be 1
    $s.Items[1].Open | Should -Be 12
    $s.Items[2].High | Should -Be 23
    $s.Items[3].Low | Should -Be 34
    $s.Items[4].Close | Should -Be 45
    $s.Items[5].BuyVolume | Should -Be 56
    $s.Items[0].SellVolume | Should -Be 61
  }

  It "can create a CandleStickSeries object" {
    $s = New-OxyCandleStickSeries `
      -X 1,2,3,4,5 `
      -High 11,12,16,16,16 `
      -Low 21,22,23,24,25 `
      -Open 31,32,33,34,35 `
      -Close 41,42,43,44,45
    $s | Should -BeOfType [OxyPlot.Series.CandleStickSeries]
    $s.Items[0].X | Should -Be 1
    $s.Items[1].High | Should -Be 12
    $s.Items[2].Low | Should -Be 23
    $s.Items[3].Open | Should -Be 34
    $s.Items[4].Close | Should -Be 45
  }

  It "can create a ColumnSeries object" {
    $s = New-OxyColumnSeries -Value 1,2 -CategoryIndex 3,4
    $s.Items[0].Value | Should -Be 1
    $s.Items[1].CategoryIndex | Should -Be 4
  }

  It "can create an ErrorColumnSeries object" {
    $s = New-OxyErrorColumnSeries -Value 1,2,3 -Error 4,5,6 -CategoryIndex 7,8,9
    $s.Items[0].Value | Should -Be 1
    $s.Items[1].Error | Should -Be 5
    $s.Items[2].CategoryIndex | Should -Be 9
  }

  It "can create a HighLowSeries object" {
    $s = New-OxyHighLowSeries `
      -X 1,2,3,4,5 `
      -High 11,12,16,16,16 `
      -Low 21,22,23,24,25 `
      -Open 31,32,33,34,35 `
      -Close 41,42,43,44,45
    $s | Should -BeOfType [OxyPlot.Series.HighLowSeries]
    $s.Items[0].X | Should -Be 1
    $s.Items[1].High | Should -Be 12
    $s.Items[2].Low | Should -Be 23
    $s.Items[3].Open | Should -Be 34
    $s.Items[4].Close | Should -Be 45
  }

  It "can create an IntervalBarSeries object" {
    $s = New-OxyIntervalBarSeries `
      -Start 1,2,3 `
      -End 11,12,13 `
      -BarTitle 21,22,23
    $s | Should -BeOfType [OxyPlot.Series.IntervalBarSeries]
    $s.Items[0].Start | Should -Be 1
    $s.Items[1].End | Should -Be 12
    $s.Items[2].Title | Should -Be 23
  }

  It "can create a LinearBarSeries object" {
    $s = New-OxyLinearBarSeries -X 1,2 -Y 3,4
    $s | Should -BeOfType [OxyPlot.Series.LinearBarSeries]
    $s.Points[0].X | Should -Be 1
    $s.Points[1].Y | Should -Be 4
  }

  It "can create a PieSeries object" {
    $s = New-OxyPieSeries -Label "aa", "bb" -Value 1,2
    $s | Should -BeOfType [OxyPlot.Series.PieSeries]
    $s.Slices[0].Label | Should -Be "aa"
    $s.Slices[1].Value | Should -Be 2
  }

  It "can create a RectangleBarSeries object" {
    $s = New-OxyRectangleBarSeries `
      -X0 1,2,3,4 `
      -Y0 11,12,13,14 `
      -X1 21,22,23,24 `
      -Y1 31,32,33,34
    $s | Should -BeOfType [OxyPlot.Series.RectangleBarSeries]
    $s.Items[0].X0 | Should -Be 1
    $s.Items[1].Y0 | Should -Be 12
    $s.Items[2].X1 | Should -Be 23
    $s.Items[3].Y1 | Should -Be 34
  }

  It "can create a ScatterErrorSeries object" {
    $s = New-OxyScatterErrorSeries -X $dataA -Y $dataB -ErrorX $dataB -ErrorY $dataA -Size $dataSize -Value $dataSize
    $s | Should -BeOfType [OxyPlot.Series.ScatterErrorSeries]
    $s.Points[0].X | Should -Be 1.5
  }

  It "can create a ScatterSeries object" {
    $s = New-OxyScatterSeries -X $dataA -Y $dataB -Size $dataSize -Value $dataSize
    $s | Should -BeOfType [OxyPlot.Series.ScatterSeries]
    $s.Points[0].X | Should -Be 1.5
  }

  It "can create a StairStepSeries object" {
    $s = New-OxyStairStepSeries -X 1,2 -Y 3,4
    $s | Should -BeOfType [OxyPlot.Series.StairStepSeries]
    $s.Points[0].X | Should -Be 1
    $s.Points[1].Y | Should -Be 4
  }

  It "can create a StemSeries object" {
    $s = New-OxyStemSeries -X 1,2 -Y 3,4
    $s | Should -BeOfType [OxyPlot.Series.StemSeries]
    $s.Points[0].X | Should -Be 1
    $s.Points[1].Y | Should -Be 4
  }

  It "can create a ThreeColorLineSeries object" {
    $s = New-OxyThreeColorLineSeries -X 1,2 -Y 3,4
    $s | Should -BeOfType [OxyPlot.Series.ThreeColorLineSeries]
    $s.Points[0].X | Should -Be 1
    $s.Points[1].Y | Should -Be 4
  }

  It "can create a TwoColorAreaSeries object" {
    $s = New-OxyTwoColorAreaSeries -X 1,2 -Y 3,4
    $s | Should -BeOfType [OxyPlot.Series.TwoColorAreaSeries]
    $s.Points[0].X | Should -Be 1
    $s.Points[1].Y | Should -Be 4
  }

  It "can create a TowColorLineSeries object" {
    $s = New-OxyTwoColorLineSeries -X 1,2 -Y 3,4
    $s | Should -BeOfType [OxyPlot.Series.TwoColorLineSeries]
    $s.Points[0].X | Should -Be 1
    $s.Points[1].Y | Should -Be 4
  }

  It "can create a VolumeSeries object" {
    $s = New-OxyVolumeSeries `
      -X 1,2,3,4,5,6 `
      -Open 11,12,16,16,16,16 `
      -High 21,22,23,24,25,26 `
      -Low 31,32,33,34,35,36 `
      -Close 41,42,43,44,45,46 `
      -BuyVolume 51,52,53,54,55,56 `
      -SellVolume 61,62,63,64,65,66
    $s | Should -BeOfType [OxyPlot.Series.VolumeSeries]
    $s.Items[0].X | Should -Be 1
    $s.Items[1].Open | Should -Be 12
    $s.Items[2].High | Should -Be 23
    $s.Items[3].Low | Should -Be 34
    $s.Items[4].Close | Should -Be 45
    $s.Items[5].BuyVolume | Should -Be 56
    $s.Items[0].SellVolume | Should -Be 61
  }

}
