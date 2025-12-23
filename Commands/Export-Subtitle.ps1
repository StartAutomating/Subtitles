function Export-Subtitle
{
    <#
    .SYNOPSIS
        Exports Subtitles
    .DESCRIPTION
        Exports Subtitles
    .EXAMPLE
        
    .LINK
        Get-Subtitle
    #>
    [Alias('Export-Subtitles','exsub')]
    param(
    [Parameter(Mandatory)]
    [string]
    $Path,

    [Parameter(ValueFromPipeline)]    
    [PSObject]
    $InputObject
    )

    $allInput = @($input)
    
    if ((-not $allInput) -and $InputObject) {
        $allInput = @($InputObject)
    }

    filter trimZeros { $_ -replace '0{0,}$'}
    filter periodsToCommas { $_ -replace '\.', ','}
    filter noTags { '<[^\>]+>' }
    filter trimWhitespace { $_ -replace '^[\s\r\n]{0,}' -replace '[\s\r\n]{0,}$'}



    $counter = 0 
    $subtitlesLines = 
        foreach ($subtitle in $allInput | 
            Sort-Object StartTime) {
            $counter++
            switch -regex ($path) {            
                '\.srt$' {                
                    $counter
                    ($subtitle.StartTime | periodsToCommas | trimZeros),
                        '-->',
                        ($subtitle.EndTime | periodsToCommas | trimZeros) -join ' '
                    "$($subtitle.Cue)"  | noTags | trimWhitespace
                    if ($counter -lt $allInput.Length) { [Environment]::NewLine}
                }
                '\.vtt$' {                
                    ($subtitle.StartTime -replace '^00:' | trimZeros),
                    '-->',
                    ($subtitle.EndTime -replace '^00:' | trimZeros) -join ' '
                    $subtitle.Cue | trimWhitespace
                    if ($counter -lt $allInput.Length) { [Environment]::NewLine}
                }
            }
        }

    if ($subtitlesLines) {
        $subtitlesLines > $Path
    }
}
