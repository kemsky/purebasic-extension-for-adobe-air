EnableExplicit

Enumeration
    #LOG_DEBUG      = 0
    #LOG_INFO       = 1
    #LOG_WARN       = 2
    #LOG_ERROR      = 3
    #LOG_DISABLED   = 4
EndEnumeration

Global LOG_LEVEL.l = #LOG_INFO

 
Interface Logger
    info(message.s)
    Debug(message.s)
    warn(message.s)
    error(message.s)
    LogToFile(message.s, level.l)
EndInterface

Structure SLogger
    VTable.l
    Functions.l[SizeOf(Logger)/4]
    name.s
    path.s
    mutex.l
EndStructure

Procedure Logger__LogToFile(*this.SLogger, message.s, level.l)
  LockMutex(*this\mutex)
  
  Define file.l, type.s
  
  Select level
    Case #LOG_DEBUG
      type = "[DEBUG]"
    Case #LOG_INFO
      type = "[INFO ]"
    Case #LOG_WARN
      type = "[WARN ]"
    Case #LOG_ERROR
      type = "[ERROR]"
  EndSelect
  
  file = OpenFile(#PB_Any, *this\path)
  If file <> 0    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(file, Lof(file))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(file, FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss", Date())+ "  " + *this\name + "  " + type + "  " + message)
    CloseFile(file)
  EndIf
  
  UnlockMutex(*this\mutex)
EndProcedure

Procedure Logger__info(*this.SLogger, message.s)
  If(LOG_LEVEL <= #LOG_INFO)
    Logger__LogToFile(*this, message, #LOG_INFO)
  EndIf
EndProcedure
  
Procedure Logger__debug(*this.SLogger, message.s)
  If(LOG_LEVEL <= #LOG_DEBUG)
    Logger__LogToFile(*this, message, #LOG_DEBUG)
  EndIf
EndProcedure

Procedure Logger__warn(*this.SLogger, message.s)
  If(LOG_LEVEL <= #LOG_WARN)
    Logger__LogToFile(*this, message, #LOG_WARN)
  EndIf
EndProcedure

Procedure Logger__error(*this.SLogger, message.s)
  If(LOG_LEVEL <= #LOG_ERROR)
    Logger__LogToFile(*this, message, #LOG_ERROR)
  EndIf
EndProcedure

Procedure New_Logger(name.s)
    Define *object.SLogger 
    *object = AllocateMemory(SizeOf(SLogger))

    CompilerIf Not Defined(LOG_FILE, #PB_Constant)
      Define file.s{1000}
      GetModuleFileName_(#Null, @file, 1000)
      *object\path = GetPathPart(file) + name + ".log"
    CompilerElse
      *object\path = #LOG_FILE
    CompilerEndIf
  
    
    *object\name = name
    *object\VTable  = *object + OffsetOf(SLogger\Functions)
    *object\Functions[0] = @Logger__info()
    *object\Functions[1] = @Logger__debug()
    *object\Functions[2] = @Logger__warn()
    *object\Functions[3] = @Logger__error()
    *object\Functions[4] = @Logger__LogToFile()
    
    *object\mutex = CreateMutex()
    ProcedureReturn *object
EndProcedure
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 10
; Folding = --
; EnableXP