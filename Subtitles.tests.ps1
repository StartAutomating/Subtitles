describe Subtitles {
    it 'Get subtitles' {
        Get-ChildItem -Path $PSScriptRoot -Recurse -File | 
            Where-Object Extension -in '.srt', '.vtt' |
                Get-Subtitle |
                    Select-Object -ExpandProperty StartTime |
                        Should -BeGreaterThan ([timespan]"00:00:00")
    }

    it 'Exports subtitles' {
        $subtitles = Get-ChildItem -Path $PSScriptRoot -Recurse -File | 
            Where-Object Extension -in '.srt', '.vtt' |
                Select-Object -First 2 | 
                    Get-Random |
                        Get-Subtitle 
        $subtitles | Export-Subtitle ./test.srt
        srt "./test.srt" | 
            Select-Object -First 1 -ExpandProperty StartTime | 
                Should -Be $subtitles[0].StartTime
        Remove-Item "./test.srt"
        $subtitles | Export-Subtitle ./test.vtt         
        vtt "./test.vtt" |         
            Select-Object -First 1 -ExpandProperty StartTime | 
                Should -Be $subtitles[0].StartTime
        Remove-Item "./test.vtt"
    }

    it 'Searches subtitles' {
        $subtitles = Get-ChildItem -Path $PSScriptRoot -Recurse -File | 
            Where-Object Extension -in '.srt', '.vtt' |
                Select-Object -First 2 | 
                    Get-Random |
                        Get-Subtitle 

        ($subtitles | Search-Subtitles -Pattern "." | Measure-Object | Select-Object -ExpandProperty Count) |
            Should -Be $subtitles.Count
    }
}
