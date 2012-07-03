EnableExplicit

;PB supports only unsigned byte (Ascii) and unsigned int (Unicode)
;unsigned long is not supported

Procedure.q getULong(*source.Long)
   ;- Reads 4 bytes from the specified memory address,
   ;  and returns the value as *unsigned* integer
   ;  (minimum = 0, maximum = 4294967295).

   If *source\l < 0
      ProcedureReturn *source\l + $100000000
   Else
      ProcedureReturn *source\l
   EndIf
EndProcedure
 
Procedure setULong(*target.Long, source.q)
   ;- Writes an *unsigned* integer of 4 bytes size
   ;  to the specified memory address.

   If source >= 0 And source <= $FFFFFFFF
      If source > $7FFFFFFF
         *target\l = source - $100000000
      Else
         *target\l = source
      EndIf
   EndIf
EndProcedure


Procedure.q fromULong(source.l)
  ProcedureReturn getULong(@source)
EndProcedure
 
Procedure.l toULong(source.q)
  Define result.l
  setULong(@result, source)
  ProcedureReturn result
EndProcedure
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 37
; Folding = -
; EnableXP