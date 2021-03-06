<% Set-StrictMode -Version 3 -%>
Set-StrictMode -Version 3

<#
.DESCRIPTION
This cmdlet creates an <% $ClassName %> object.

<% ../tools/Insert-Help.ps1 $Document $ClassName -%>

<% if ($SeriesElement -ne $null) { -%>
.PARAMETER InputObject
Sets the source of the data set.

<% $SeriesElement.Element | foreach { -%>
.PARAMETER <% $_.Name %>
Sets the column <% $_.Name %> of the data set.

<% } -%>
.PARAMETER Group
Specifies groups to which each element of the data set belongs.

If this parameter is set, the data set will be grouped by these values, and multiple series will be produced for each group.

<% $SeriesElement.Element | foreach { -%>
.PARAMETER <% $_.Name %>Name
Specifies a property name of the input objects to be assigned to the column <% $_.Name %> of the data set.

<% } -%>
.PARAMETER GroupName
Specifies a property name of the input objects to be treated as groups.

If this parameter is set, the data set will be grouped by the values of this property, and multiple series will be produced for each group.

.PARAMETER GroupingKeys
Specifies effective groups and these order.

This option is useful when you will select groups, or specify the order of the groups shown in the legend.

<% } -%>
.PARAMETER Options
Sets properties of the object.

.PARAMETER Style
Sets a style of the object.

.PARAMETER AddTo
Specifies a plot model to which the object will be added.

.INPUTS
<% if ($SeriesElement -ne $null) { -%>
You can send any object to the cmdlet as the source of the data set.
<% } else { -%>
You cannot pipe input to the cmdlet.
<% } -%>
#>
function New-Oxy<% $ClassName -replace "^([^.]+\.)*", "" %> {
  [cmdletbinding()]
  [OutputType([<% $ClassName %>[]], [void])]
  param(
<% if ($SeriesElement -ne $null) { -%>
    [Parameter(ValueFromPipeline=$true)]
    [object]$InputObject,

<% $SeriesElement.Element | foreach { -%>
    [<% ..\tools\Get-GeneralTypeName.ps1 $_.Class %>[]]$<% $_.Name %> = @(),
<% } -%>
    [string[]]$Group = @(),

<% $SeriesElement.Element | foreach { -%>
    [string]$<% $_.Name %>Name,
<% } -%>
    [string]$GroupName,
    [string[]]$GroupingKeys = @(),

<% } -%>
<% ..\tools\Insert-PropertyList.ps1 -OutputType "param" -ClassName $ClassName -Indent 4 -%>

    [hashtable]$Options = @{},

    [string]$Style = "default",
    [OxyPlot.PlotModel]$AddTo
  )

begin {

  if (!(Test-OxyStyleName $Style)) {
    Write-Error "Unknown style: '$Style'"
    return
  }

  $info = [PSCustomObject]@{
<% if ($XAxisElement -ne $null) { -%>
    XAxisTitle = "<% $XAxisElement.Name %>"
<% } else { -%>
    XAxisTitle = $null
<% } -%>
<% if ($YAxisElement -ne $null) { -%>
    YAxisTitle = "<% $YAxisElement.Name %>"
<% } else { -%>
    YAxisTitle = $null
<% } -%>
    XDataType = $null
    YDataType = $null
<% if ($SeriesElement -ne $null) { -%>
    GroupName = $GroupName
<% } else { -%>
    GroupName = $null
<% } -%>
    CategoryNames = @()
    CategoryTitle = $null
  }

<% if ($XAxisElement -ne $null) { -%>
  if ($PSBoundParameters.ContainsKey("<% $XAxisElement.Name %>Name")) { $info.XAxisTitle = $<% $XAxisElement.Name %>Name }
<% } -%>
<% if ($YAxisElement -ne $null) { -%>
  if ($PSBoundParameters.ContainsKey("<% $YAxisElement.Name %>Name")) { $info.YAxisTitle = $<% $YAxisElement.Name %>Name }
<% } -%>
<% if ($SeriesElement -ne $null -and $SeriesElement.Element.Name -Contains "Category") { -%>
  if ($PSBoundParameters.ContainsKey("CategoryName")) { $info.CategoryTitle = $CategoryName }
<% } %>

<% if ($SeriesElement -ne $null) { -%>
<% foreach ($e in $SeriesElement.Element) { -%>
  $<% $e.Name %>Data = New-Object Collections.Generic.List[<% ..\tools\Get-GeneralTypeName.ps1 $e.Class %>]
<% } -%>
  $GroupData = New-Object Collections.Generic.List[string]

<% } -%>
}

<% if ($SeriesElement -ne $null) { -%>
process {
  if ($InputObject -ne $null) {
<% foreach ($e in $SeriesElement.Element) { -%>
    if ($PSBoundParameters.ContainsKey("<% $e.Name %>Name")) { $<% $e.Name %>Data.Add($InputObject.$<% $e.Name %>Name) }
<% } -%>
    if ($PSBoundParameters.ContainsKey("GroupName")) { $GroupData.Add($InputObject.$GroupName) }
  }
}
<% } -%>

end {
<% if ($SeriesElement -ne $null) { -%>
<% foreach ($e in $SeriesElement.Element) { -%>
  if ($<% $e.Name %>Data.Count -gt 0 -and $<% $e.Name %>.Count -gt 0) { Write-Error "Data set of '<% $e.Name %>' is given in two ways"; return }
<% } -%>
  if ($GroupData.Count -gt 0 -and $Group.Count -gt 0) { Write-Error "Data set of 'Group' is given in two ways"; return }

<% foreach ($e in $SeriesElement.Element) { -%>
  $<% $e.Name %>Data.AddRange($<% $e.Name %>)
<% } -%>
  $GroupData.AddRange($Group)

<% if ($SeriesElement -ne $null -and $SeriesElement.Element.Name -Contains "Category") { -%>
  $categoryNames = $CategoryData | Sort-Object -Unique
  $categoryIndexMap = @{}
  $index = 0
  foreach ($c in $categoryNames) {
    $categoryIndexMap[$c] = $index
    ++$index
  }
  $info.CategoryNames = $categoryNames

<% } -%>
  if ($GroupData.Count -gt 0) {
    $groups = @{}
    foreach ($e in $GroupData) {
      $groups[$e] = 1
    }
    if ($GroupingKeys.Count -eq 0) {
      $GroupingKeys = $groups.Keys | Sort
    }
    $grouping = $true
  }
  else {
    $GroupingKeys = @("dummy")
    $grouping = $false
  }

<% if ($ClassName -match "HistogramSeries") { -%>
  $hist = New-Object Horker.OxyPlotCli.Series.Histogram
  $hist.BinCount = Convert-ParameterValue double $BinCount
  if ([double]::IsNaN($hist.BinCount)) { $hist.BinCount = 0.0 }
  $hist.BinWidth = Convert-ParameterValue double $BinWidth
  if ([double]::IsNaN($hist.BinWidth)) { $hist.BinWidth = 0.0 }
  $hist.BinOffset = Convert-ParameterValue double $BinOffset
  if ([double]::IsNaN($hist.BinOffset)) { $hist.BinOffset = 0.0 }

  $all = New-Object Collections.Generic.List[double]
  foreach ($v in $ValueData) {
    $v = Convert-ParameterValue double $v
    $all.Add($v)
  }

  $hist.UpdateBinWidth($all)
  $hist.FillBins($all)

  $info.CategoryNames = $hist.GetLabels($BinLabelFormatString)

<% } -%>
  $dataCount = (<% ($SeriesElement.Element.Name -replace "(.+)", '$$$1Data.Count') -join ", " %> | Measure -Maximum).Maximum
  foreach ($group in $GroupingKeys) {

<% } # if ($SeriesElement -ne $null) -%>
<% if ($ClassName -match "HistogramSeries") { -%>
    $series = New-Object <% $ClassName %> $hist
<% } else { -%>
    $series = New-Object <% $ClassName %>
<% } -%>

<% if ($SeriesElement -ne $null) { -%>
    if ($grouping) {
      $series.Title = $group
    }

<% } # if ($SeriesElement -ne $null) -%>
<% if ($SeriesElement -ne $null) { -%>
    for ($i = 0; $i -lt $dataCount; ++$i) {
      if ($grouping -and $GroupData[$i] -ne $group) {
        continue
      }
<% foreach ($e in $SeriesElement.Element) { -%>
<%   if ($e.Name -eq "CategoryIndex") { -%>
      if ($i -lt $CategoryIndexData.Count) {
        $CategoryIndexElement = $CategoryIndexData[$i]
      }
      elseif ($i -lt $CategoryData.Count) {
        $CategoryIndexElement = $categoryIndexMap[$CategoryData[$i]]
      }
      elseif ($categoryIndexMap.Count -gt 0) {
        $CategoryIndexElement = ($categoryIndexMap.Values | Measure-Object -Maximum).Maximum
      }
      else {
        $CategoryIndexElement = 0
      }
<%   } elseif ($e.Name -eq "X" -and $ClassName -match "Horker.OxyPlotCli.Series.BoxPlotSeries") { -%>
      if ($i -lt $XData.Count) {
        $XElement = $XData[$i]
      }
      elseif ($i -lt $CategoryData.Count) {
        $XElement = $categoryIndexMap[$CategoryData[$i]]
      }
      elseif ($categoryIndexMap.Count -gt 0) {
        $XElement = ($categoryIndexMap.Values | Measure-Object -Maximum).Maximum
      }
      else {
        $XElement = 0
      }
<%   } else { -%>
      if ($i -lt $<% $e.Name %>Data.Count) {
        $<% $e.Name %>Element = $<% $e.Name %>Data[$i]
      }
      else {
        $<% $e.Name %>Element = $null
      }
<%   } -%>
<% } -%>
      <% $SeriesElement.Cmdlet %> $series<% $SeriesElement.Element | where { $_.Name -ne "Category" } | foreach { %> $<% $_.Name %>Element<% } %>
    }

<% } # if ($SeriesElement -ne $null) -%>
<% if ($XAxisElement -ne $null) { -%>
    if ($<% $XAxisElement.Name %>Data.Count -gt 0) { $info.XDataType = Get-ValueType $<% $XAxisElement.Name %>Data[0] }
<% } -%>
<% if ($YAxisElement -ne $null) { -%>
    if ($<% $YAxisElement.Name %>Data.Count -gt 0) { $info.YDataType = Get-ValueType $<% $YAxisElement.Name %>Data[0] }
<% } -%>

    $series = $series | Add-Member -PassThru NoteProperty _Info $info

    Apply-OxyStyle $series $Style $MyInvocation

    $props = $PROPERTY_HASH["<% $ClassName %>"]
    Assign-ParametersToProperties $props $PSBoundParameters $Options $series

<% if ($ClassName -match "^Horker\..+(BoxPlot|Histogram)Series$") { -%>
    $series.ProcessRawValues()

<% } -%>
    if ($AddTo -ne $null) {
      Add-OxyObjectToPlotModel $series $AddTo -NoRefresh
    }
    else {
      $series
    }
<% if ($SeriesElement -ne $null) { -%>
  }
<% } # if ($SeriesElement -ne $null) -%>

  if ($AddTo -ne $null) {
    $AddTo.InvalidatePlot($true)
  }
}
}
