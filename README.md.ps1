@'

# Subtitles

Subtitles is a simple module for Subtitles.

'@

@'


## Installing and Importing

You can install Subtitles from the PowerShell Gallery:

~~~PowerShell
Install-Module Subtitles
~~~

Once installed, you can import it using Import-Module

~~~PowerShell
Import-Module Subtitles
~~~

'@

@'

## Examples

This module lets us parse, export, and search subtitles in `.srt` and `.vtt`.

For example:

~~~PowerShell
Get-Childitem -Recurse -Filter *.srt | 
    Get-Subtitle
~~~

We can also use any of the aliases `subtitle`, `subtitles`, `srt`, or `vtt`:

~~~PowerShell
subtitle ./Examples/Example.srt
subtitles ./Examples/Example.srt
srt ./Examples/Example.srt
vtt ./Examples/Example.vtt
~~~

We can export subtitles by piping them.  This will also convert a subtitle from one format to another.

~~~PowerShell
Get-Childitem -Recurse -Filter *.srt | 
    Select -First 1 | 
    Get-Subtitle | 
    Export-Subtitle ./test.vtt

Get-Subtitle ./test.vtt
~~~

We can search subtitle.  This can make it easy to when someone said something.

~~~PowerShell
Get-Childitem -Recurse -Filter *.srt | 
    Select -First 1 | 
    Get-Subtitle |
    Search-Subtitle -Pattern '.'
~~~
'@
