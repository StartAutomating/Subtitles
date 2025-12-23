function Search-Subtitle
{
    <#
    .SYNOPSIS
        Searches Subtitles
    .DESCRIPTION
        Searches Subtitles for a phrase, pattern, or wildcard.
    .EXAMPLE
        # Set subtitles and search for a phrase
        Get-Subtitle ./Example.srt | Search-Subtitle we
    .EXAMPLE
        # Get subtitles and search for a wildcard
        Get-Subtitle ./Example.srt | Search-Subtitle -Wildcard '*we*'
    .EXAMPLE
        # Get subtitles and search for a regular expression
        Get-Subtitle ./Example.srt | Search-Subtitle -Pattern "I[\s']"
    .EXAMPLE
        # Get subtitles and check for invoke-expression (in case of malicious subtitles)
        Get-Subtitle ./Example.srt | Search-Subtitle -Pattern 'invoke-expression|iex'
    .LINK
        Get-Subtitle
    #>
    [Alias('Search-Subtitles','srsub')]    
    param(
    # The target phrase
    [SupportsWildcards()]
    [string]
    $Phrase,
    
    # The search wildcard
    [SupportsWildcards()]
    [string]
    $Wildcard,

    # A regular expression pattern.
    [PSObject]
    $Pattern,

    # The input object.  This should be a series of subtitles.
    [Parameter(ValueFromPipeline)]    
    [PSObject]
    $InputObject
    )

    process {
        if ($Phrase -and $InputObject.Cue -like "*$Phrase*") {
            $InputObject
        }
        elseif ($Wildcard -and $InputObject.Cue -like $Wildcard) {
            $InputObject
        }
        elseif ($Pattern -and $InputObject.Cue -match $Pattern) {
            $InputObject
        }        
    }
}