EnableExplicit

;PB source encoding must be set to UTF8

;PB compiler must be set to create Unicode executable (WinApi)

;WideCharToMultiByte
#CP_UTF8 = 65001

Procedure.s Utf8ToUnicode(string.s)
  ;- Converts UCS2 to UTF8
  Define size.i, result.s
  size = MultiByteToWideChar_(#CP_UTF8, 0, @string, -1, 0, 0)
  result = Space(size + 1)
  MultiByteToWideChar_(#CP_UTF8, 0 , @string, -1, @result, size)
  ProcedureReturn result
EndProcedure

Procedure.s UnicodeToUtf8(string.s)
  ;- Converts UTF8 to UCS2
  Define size.i, result.s
  size = WideCharToMultiByte_(#CP_UTF8, 0, @string, -1, 0, 0, 0, 0)
  result = Space(size + 1)
  WideCharToMultiByte_(#CP_UTF8, 0 , @string, -1, @result, size, 0, 0)
  ProcedureReturn result
EndProcedure

;from PB help:
;  If you want to return a string out of a DLL, the string has to be declared as Global before using it.
Procedure.l asGlobal(string.s)
  ;- Converts UCS2 to Ascii
  Define *result.Ascii = AllocateMemory(Len(string) + 1)
  PokeS(*result, string, -1, #PB_Ascii)
  ProcedureReturn *result
EndProcedure
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 32
; Folding = -
; EnableXP