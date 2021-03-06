Set-StrictMode -Version 3

############################################################
# Template files

$TEMPLATES = @(
  "OxyWindow.template.ps1"
  "OxyPlot.Series.FunctionSeries.template.ps1"
)

############################################################
# Data point definitions

$DATAPOINTS = @{}

$DATAPOINTS.Line = @{
  Cmdlet = "Add-OxyLineSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "double"; Axis = "X" },
    @{ Name = "Y"; Class = "double"; Axis = "Y" }
  )
}

$DATAPOINTS.Scatter = @{
  Cmdlet = "Add-OxyScatterSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "double"; Axis = "X" },
    @{ Name = "Y"; Class = "double"; Axis = "Y" },
    @{ Name = "Size"; Class = "double" },
    @{ Name = "Value"; Class = "double" }
  )
}

$DATAPOINTS.ScatterError = @{
  Cmdlet = "Add-OxyScatterErrorSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "double"; Axis = "X" },
    @{ Name = "Y"; Class = "double"; Axis = "Y" },
    @{ Name = "ErrorX"; Class = "double" },
    @{ Name = "ErrorY"; Class = "double" },
    @{ Name = "Size"; Class = "double" },
    @{ Name = "Value"; Class = "double" }
  )
}

$DATAPOINTS.Area = @{
  Cmdlet = "Add-OxyAreaSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "double"; Axis = "X" },
    @{ Name = "Y"; Class = "double"; Axis = "Y" },
    @{ Name = "X2"; Class = "double" },
    @{ Name = "Y2"; Class = "double" }
  )
}

$DATAPOINTS.CandleStick = @{
  Cmdlet = "Add-OxyCandleStickSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "double"; Axis = "X" },
    @{ Name = "High"; Class = "double" },
    @{ Name = "Low"; Class = "double" },
    @{ Name = "Open"; Class = "double" },
    @{ Name = "Close"; Class = "double"; Axis = "Y" }
  )
}

$DATAPOINTS.Pie = @{
  Cmdlet = "Add-OxyPieSeriesPoint"
  Element = @(
    @{ Name = "Label"; Class = "string" },
    @{ Name = "Value"; Class = "double" },
    @{ Name = "Fill"; Class = "string" },
    @{ Name = "IsExploded"; Class = "bool" }
  )
}

$DATAPOINTS.Bar = @{
  Cmdlet = "Add-OxyBarSeriesPoint"
  Element = @(
    @{ Name = "Value"; Class = "double"; Axis = "X" },
    @{ Name = "CategoryIndex"; Class = "int"; Axis = "Y" },
    @{ Name = "Category"; Class = "string" }
  )
}

$DATAPOINTS.Column = @{
  Cmdlet = "Add-OxyColumnSeriesPoint"
  Element = @(
    @{ Name = "Value"; Class = "double"; Axis = "Y" },
    @{ Name = "CategoryIndex"; Class = "int"; Axis = "X" }
    @{ Name = "Category"; Class = "string" }
  )
}

$DATAPOINTS.ErrorColumn = @{
  Cmdlet = "Add-OxyErrorColumnSeriesPoint"
  Element = @(
    @{ Name = "Value"; Class = "double"; Axis = "X" },
    @{ Name = "Error"; Class = "double" },
    @{ Name = "CategoryIndex"; Class = "int"; Axis = "Y" }
    @{ Name = "Category"; Class = "string" }
  )
}

$DATAPOINTS.IntervalBar = @{
  Cmdlet = "Add-OxyIntervalBarSeriesPoint"
  Element = @(
    @{ Name = "Start"; Class = "double" },
    @{ Name = "End"; Class = "double" },
    @{ Name = "BarTitle"; Class = "string" }, # renamed from Title to avoid conflict against the Series.InternalBarSeries property
    @{ Name = "Category"; Class = "string" }
  )
}

$DATAPOINTS.RectangleBar = @{
  Cmdlet = "Add-OxyRectangleBarSeriesPoint"
  Element = @(
    @{ Name = "X0"; Class = "double"; Axis = "X" },
    @{ Name = "Y0"; Class = "double"; Axis = "Y" },
    @{ Name = "X1"; Class = "double" },
    @{ Name = "Y1"; Class = "double" },
    @{ Name = "Category"; Class = "string" }
  )
}

$DATAPOINTS.TornadoBar = @{
  Cmdlet = "Add-OxyTornadoBarSeriesPoint"
  Element = @(
    @{ Name = "Minimum"; Class = "double"; Axis = "X" },
    @{ Name = "Maximum"; Class = "double" },
    @{ Name = "BarBaseValue"; Class = "double" }, # renamed from BaseValue to avoid conflict against the Series.TornadoBarSeries property
    @{ Name = "MinimumColor"; Class = "string" },
    @{ Name = "MaximumColor"; Class = "string" },
    @{ Name = "Category"; Class = "string" }
  )
}

$DATAPOINTS.CandleStickAndVolume = @{
  Cmdlet = "Add-OxyCandleStickAndVolumeSeriesPoint"
  Element = @(
    @{ Name = "X"; Class = "double"; Axis = "X" },
    @{ Name = "Open"; Class = "double" },
    @{ Name = "High"; Class = "double" },
    @{ Name = "Low"; Class = "double" },
    @{ Name = "Close"; Class = "double"; Axis = "Y" },
    @{ Name = "BuyVolume"; Class = "double" },
    @{ Name = "SellVolume"; Class = "double" }
  )
}

#$DATAPOINTS.BoxPlot = @{
#  Cmdlet = "Add-OxyBoxPlotSeriesPoint"
#  Element = @(
#    @{ Name = "X"; Class = "double"; Axis = "X" },
#    @{ Name = "LowerWhisker"; Class = "double" },
#    @{ Name = "BoxBottom"; Class = "double" },
#    @{ Name = "Median"; Class = "double"; Axis = "Y" },
#    @{ Name = "BoxTop"; Class = "double" },
#    @{ Name = "UpperWhisker"; Class = "double" },
#    @{ Name = "Outlier"; Class = "double[]" },
#    @{ Name = "Category"; Class = "string" }
#  )
#}

$DATAPOINTS.BoxPlotRaw = @{
  Cmdlet = "Add-OxyBoxPlotSeriesRawPoint"
  Element = @(
    @{ Name = "X"; Class = "double"; Axis = "X" },
    @{ Name = "Value"; Class = "double"; Axis = "Y" },
    @{ Name = "Category"; Class = "string" }
  )
}

$DATAPOINTS.Histogram = @{
  Cmdlet = "Add-OxyHistogramSeriesRawPoint"
  Element = @(
    @{ Name = "Value"; Class = "double"; Axis = "X" }
  )
}

([string[]]$DATAPOINTS.Keys) | foreach {
  $value = [PsCustomObject]$DATAPOINTS.$_
  $value.Element = @($value.Element | foreach { [PSCustomObject]$_ })
  $DATAPOINTS.$_ = $value
}

############################################################
# Series template definitions

$SERIES_TEMPLATES = @(
  @{
    ClassName = "OxyPlot.Series.AreaSeries"
    SeriesElement = $DATAPOINTS.Area
  },

  @{
    ClassName = "OxyPlot.Series.BarSeries"
    SeriesElement = $DATAPOINTS.Bar
  },

#  @{
#    ClassName = "OxyPlot.Series.BoxPlotSeries"
#    SeriesElement = $DATAPOINTS.BoxPlot
#  },

  @{
    ClassName = "Horker.OxyPlotCli.Series.BoxPlotSeries"
    SeriesElement = $DATAPOINTS.BoxPlotRaw
  },

  @{
    ClassName = "OxyPlot.Series.CandleStickAndVolumeSeries"
    SeriesElement = $DATAPOINTS.CandleStickAndVolume
  },

  @{
    ClassName = "OxyPlot.Series.CandleStickSeries"
    SeriesElement = $DATAPOINTS.CandleStick
  },

  @{
    ClassName = "OxyPlot.Series.ColumnSeries"
    SeriesElement = $DATAPOINTS.Column
  },

  @{
    ClassName = "OxyPlot.Series.ContourSeries"
    SeriesElement = $null
  },

  @{
    ClassName = "OxyPlot.Series.ErrorColumnSeries"
    SeriesElement = $DATAPOINTS.ErrorColumn
  },

  @{
    ClassName = "OxyPlot.Series.HeatMapSeries"
    SeriesElement = $null
  },

  @{
    ClassName = "OxyPlot.Series.HighLowSeries"
    SeriesElement = $DATAPOINTS.CandleStick
  },

  @{
    ClassName = "OxyPlot.Series.IntervalBarSeries"
    SeriesElement = $DATAPOINTS.IntervalBar
  },

  @{
    ClassName = "OxyPlot.Series.LinearBarSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.LineSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.PieSeries"
    SeriesElement = $DATAPOINTS.Pie
  }

  @{
    ClassName = "OxyPlot.Series.RectangleBarSeries"
    SeriesElement = $DATAPOINTS.RectangleBar
  },

  @{
    ClassName = "OxyPlot.Series.ScatterErrorSeries"
    SeriesElement = $DATAPOINTS.ScatterError
  },

  @{
    ClassName = "OxyPlot.Series.ScatterSeries"
    SeriesElement = $DATAPOINTS.Scatter
  },

  @{
    ClassName = "OxyPlot.Series.StairStepSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.StemSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.ThreeColorLineSeries"
    SeriesElement = $DATAPOINTS.Line
  },

  @{
    ClassName = "OxyPlot.Series.TornadoBarSeries"
    SeriesElement = $DATAPOINTS.TornadoBar
  }

  @{
    ClassName = "OxyPlot.Series.TwoColorAreaSeries"
    SeriesElement = $DATAPOINTS.Area
  },

  @{
    ClassName = "OxyPlot.Series.TwoColorLineSeries"
    SeriesElement = $DATAPOINTS.Line
  }

  @{
    ClassName = "OxyPlot.Series.VolumeSeries"
    SeriesElement = $DATAPOINTS.CandleStickAndVolume
  }

  @{
    ClassName = "Horker.OxyPlotCli.Series.HistogramSeries"
    SeriesElement = $DATAPOINTS.Histogram
  }
)

$SERIES_TEMPLATES = $SERIES_TEMPLATES | foreach {
  [PSCustomObject]$_
}

############################################################

$TOOL = "$PSScriptRoot\..\tools\Insert-PropertyList.ps1"

foreach ($t in $TEMPLATES) {
  task "build_$t" `
    -Inputs ($t -replace "^", "$PSScriptRoot\..\templates\"), $TOOL `
    -Outputs ($t -replace "^(.+)\.template\.ps1$", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Jobs {
      Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

############################################################

$thisFile = "$PSScriptRoot\..\templates\template.build.ps1"
$helperFile1 = "$PSScriptRoot\..\tools\Insert-PropertyList.ps1"
$helperFile2 = "$PSScriptRoot\..\tools\Insert-Help.ps1"
$defaultTemplate = "XYSeries.template.ps1"

$Document = [xml](Get-Content -Encoding utf8 $PSScriptRoot\..\lib\OxyPlot.Core.1.0.0\lib\net40\OxyPlot.XML)

foreach ($t in $SERIES_TEMPLATES) {
  $template = $defaultTemplate
  if ($t.PSObject.Properties.Name -Contains "Template") {
    $template = $t.Template
  }

  task "build_$($t.ClassName)" `
    -Inputs ($template -replace "^", "$PSScriptRoot\..\templates\"), $thisFile, $helperFile1, $helperFile2 `
    -Outputs ($t.ClassName -replace "(.+)", "$PSScriptRoot\..\OxyPlotCli\`$1.ps1") `
    -Data $t `
    -Jobs {
      $ClassName = $Task.Data.ClassName
      $SeriesElement = $Task.Data.SeriesElement

      # XAxisElement/YAxisElement
      $XAxisElement = $null
      $YAxisElement = $null
      if ($SeriesElement -ne $null) {
        $XAxisElement = $SeriesElement.Element | where { $_.PSObject.Properties.Name -Contains "Axis" -and $_.Axis -eq "X" }
        $YAxisElement = $SeriesElement.Element | where { $_.PSObject.Properties.Name -Contains "Axis" -and $_.Axis -eq "Y" }
      }

      Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
    }
}

############################################################

$seriesCmdlets = $SERIES_TEMPLATES | foreach {
  $_.ClassName -replace "^(.+\.)*(.+)", 'New-Oxy$2'
} | Sort

$seriesAliases = $seriesCmdlets | foreach {
  ($_ -replace "^New-(.+)Series$", '$1').ToLower()
} | Sort

task "build_OxyPlotCli.psd1" `
  -Inputs "$PSScriptRoot\..\templates\OxyPlotCli.template.psd1", $thisFile `
  -Outputs "$PSScriptRoot\..\OxyPlotCli\OxyPlotCli.psd1" `
  -Jobs {
    Get-Content $Inputs[0] | Invoke-TemplateEngine | Set-Content $Outputs
  }

############################################################

task . (@($TEMPLATES -replace "^", "build_") + @($SERIES_TEMPLATES.ClassName -replace "^", "build_") + @("build_OxyPlotCli.psd1"))
