$plotModel = New-OxyPlotModel `
  -Title "Polar plot (axis Minimum = 10 and Maximum = 20)" `
  -Subtitle "Archimedean spiral with equation r(��) = �� for 0 < �� < 6��" `
  -PlotType Polar `
  -PlotAreaBorderThickness 0 `
  -PlotMargins 60, 20, 4, 40

$axis1 = New-OxyAngleAxis `
   -MajorStep ([Math]::PI / 4) `
   -MinorStep ([Math]::PI / 16) `
   -MajorGridlineStyle Solid `
   -MinorGridlineStyle Solid `
   -FormatAsFractions $true `
   -FractionUnit ([Math]::PI) `
   -FractionUnitSymbol "��" `
   -Minimum 0 `
   -Maximum (2 * [Math]::PI)

$axis2 = New-OxyMagnitudeAxis `
  -Minimum 10 `
  -Maximum 20 `
  -MajorGridlineStyle Solid `
  -MinorGridlineStyle Solid

$plotModel.Axes.Add($axis1)
$plotModel.Axes.Add($axis2)

$series = New-OxyFunctionSeries -Fx { $t } -Fy { $t } -T0 0 -T1 ([Math]::PI * 6) -Dt 0.01

$plotModel.Series.Add($series)

$plotModel
