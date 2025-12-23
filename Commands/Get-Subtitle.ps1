function Get-Subtitle
{
    <#
    .SYNOPSIS
        Gets subtitles
    .DESCRIPTION
        Gets subtitles from any input files or input text.

        Both SRT and VTT files are supported.

        In practice, any file that contains lines that look like SRT or VTT will be considered as having subtitles.
    .EXAMPLE
        Get-Childitem *.srt -Recurse | Get-Subtitle
    .EXAMPLE
        subtitle ./Examples/Example.srt
    .EXAMPLE
        vtt ./Examples/Example.vtt
    .LINK
        Export-Subtitle
    .LINK
        Search-Subtitle
    #>
    [Alias(
            'Get-Subtitles',
            'Import-Subtitle','Import-Subtitles',
            'subtitle','subtitles',
            'srt','vtt',
            'gsub','imsub'
    )]
    param()
   
    $Patterns = @{
        SRT = [Regex]::new(
'(?<Subtitle_SRT>
(?<=(?:[\r\n]|^))\d+                       # SRT Files Contain an Index digit
[\s\n\r]+                                  # Followed by whitespace and a newline
(?<StartTime>[\d\:\,\.]+)                  # Followed by a Timespan, likely using comma as the separator
\s\-\-\>\s                                 # Followed by --> (with a space on each side)
(?<EndTime>[\d\:\,\.]+)                    # Followed by another Timespan
(?<Cue>(?:.|\s){0,}?(?=\z|(?<=[\r\n])\d+)) # Any text until the next marker is the subtitle text

)', 'IgnoreCase,IgnorePatternWhitespace'
)
        VTT = [Regex]::new(
'

(?<Subtitle_VTT>
(?<StartTime>(?<=(?:[\r\n]|^))[\d\:\,\.]+)         # VTT Subtitles start with a StartTime
\s{1,}\-\-\>\s{1,}                                 # Followed by --> (surrounded by a space)
(?<EndTime>[\d\:\,\.]+)                            # Followed by an EndTime
(?<Style>.+?(?=[\r\n]))                            # Anything until the end of the line is considered a style
[\r\n]+                                            # Match the newline
(?<Cue>(?:.|\s){0,}?(?=\z|([\r\n]{1,}[\d\:\,\.]+))) # Anything until the next timespan is a Cue

)
', 'IgnoreCase,IgnorePatternWhitespace'
        )
    }
    

    $allInputAndArgs = @($input) + @(if ($args) { $args })

    filter subTime {
        
        $in = $_
        $original = "$in"
        # srt is originally French, and so uses commas instead of periods
        $in = $in -replace ',', '.'
        # and vtt omits hours, which need to be added
        if ($in -notlike '*:*:*') {
            $in = $in -replace '^', '00:'
        }

        $inTimespan = $in -as [timespan]
        if ($inTimespan) {
            $inTimespan
        } else {
            $original
        }
    }

    Update-TypeData -TypeName Subtitle -DefaultDisplayPropertySet StartTime,EndTime,Cue -Force

    foreach ($in in $allInputAndArgs) {
        if (Test-path $in -ErrorAction Ignore) {
            $in = Get-Item $in
        }

        $subtitleInfo = [Ordered]@{}
        if ($in -is [IO.FileInfo]) {
            $subtitleInfo.File = $in
            $in = Get-Content -LiteralPath $in.Fullname  -Raw
        }

        $subtitleInfo.Text = "$in"
        foreach ($pattern in $patterns.Values) {
            $matched = $false
            foreach ($match in @($pattern.Matches(
                "$($subtitleInfo.Text)"
            ))) {
                $matched = $true
                [PSCustomObject]@{
                    PSTypeName = 'Subtitle'
                    StartTime  = 
                        $match.Groups['StartTime'].Value | subTime
                    EndTime  =
                        $match.Groups['EndTime'].Value | subTime
                    Cue = $match.Groups['Cue'].Value
                    File = $subtitleInfo.File
                    Match = $match
                }
            }
            if ($matched) { break }
        }
    }
}