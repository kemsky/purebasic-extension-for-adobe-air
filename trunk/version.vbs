'This script sets air version to vb application version, which is set to autoincrement

option explicit

Dim command, file, exe, document, fso, textStream, xml, result, versionNode

Set command = WScript.Arguments

if(command.Count <> 2) then
  WScript.echo "Wrong arguments count!"
  WScript.Quit 1 
else
  file = command.item(0)
  exe = command.item(1)  
  WScript.echo "Extension: " & exe
end if

Set fso = CreateObject("Scripting.FileSystemObject")

Set textStream = fso.OpenTextFile(file, 1, false)

if(textStream is Nothing) then
  WScript.echo "Can not open file: " & file
  WScript.Quit 1
else
  WScript.echo "Read file: " & file 
end if

xml = textStream.ReadAll() 

textStream.close 

Set document = CreateObject("MSXML2.DOMDocument")

result = document.loadXML(xml)

if(not result) then
    WScript.echo "Load XML: False"
    WScript.Quit 1
else
    WScript.echo "Load XML: True"
end if

Set versionNode = document.selectSingleNode("//application/versionNumber")

WScript.echo "Version old: " & versionNode.Text

Wscript.Echo "Version new: " & fso.GetFileVersion(exe)

versionNode.Text = Mid(fso.GetFileVersion(exe), 1, InstrRev(fso.GetFileVersion(exe), ".") - 1)

document.save file

Wscript.Echo "Save success"

Set versionNode = Nothing
Set document = Nothing
Set textStream = Nothing
Set fso = Nothing