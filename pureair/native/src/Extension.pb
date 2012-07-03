EnableExplicit

;#LOG_FILE = "C:\pureair.log"

XIncludeFile "Unsigned.pb"
XIncludeFile "Unicode.pb"
XIncludeFile "Logger.pb"
XIncludeFile "FlashRuntimeExtensions.pb"

Global *log.Logger

Structure MessageParameters
  text.s
  title.s
  dwFlags.l
  ctx.l
EndStructure

ProcedureDLL AttachProcess(Instance)
  ;- This procedure is called once, when the program loads the library
  ;  for the first time. All init stuffs can be done here (but not DirectX init)
  Define processID.l = GetCurrentProcessId_()
  
  LOG_LEVEL = #LOG_DEBUG
  
  *log = New_Logger("pureair.dll")
  
  *log\info(#CRLF$)
  *log\info(#CRLF$)
  *log\info("----------------------------------------------------------------")
  *log\info("AttachProcess: " + Str(processID) + ", instance = " + Str(Instance))
EndProcedure


ProcedureDLL DetachProcess(Instance)
  ;- Called when the program release (free) the DLL
  *log\info("DetachProcess: " + Str(Instance))
  *log\info("----------------------------------------------------------------")
  FreeMemory(*log)
EndProcedure


;- Both are called when a thread in a program call Or release (free) the DLL
ProcedureDLL AttachThread(Instance)
  *log\Debug("AttachThread: " + Str(Instance))
EndProcedure


ProcedureDLL DetachThread(Instance)
  *log\Debug("DetachThread: " + Str(Instance))
EndProcedure


Procedure ModalMessage(*params.MessageParameters)
  Define result.l, code.l
  code = MessageRequester(*params\title, *params\text, *params\dwFlags)
  result = FREDispatchStatusEventAsync(*params\ctx, asGlobal("closed"), asGlobal(Str(code)))
  *log\Debug (ResultDescription(result, "FREDispatchStatusEventAsync"))
EndProcedure

;CDecl
ProcedureC.l showDialog(ctx.l, funcData.l, argc.l, *argv.FREObjectArray)
  *log\Debug("Invoked showDialog")
  
  ;function data example
  Define funcDataS.s
  funcDataS = PeekS(funcData, -1, #PB_Ascii)
  *log\Debug("funcData=" + funcDataS)
  
  *log\Debug("arg size: " + Str(fromULong(argc)))

  Define result.l, resultObject.l, length.l, booleanArg.l, dwFlags.l, message.s, *string.Ascii
  
  result = FREGetObjectAsBool(*argv\object[0], @booleanArg)
  *log\Debug("result=" + ResultDescription(result, "FREGetObjectAsBool"))
  
  result = FREGetObjectAsInt32(*argv\object[1], @dwFlags)
  *log\Debug("result=" + ResultDescription(result, "FREGetObjectAsInt32"))
  
  result = FREGetObjectAsUTF8(*argv\object[2], @length, @*string)
  *log\Debug("result=" + ResultDescription(result, "FREGetObjectAsUTF8"))
  message = PeekS(*string, fromULong(length) + 1)
  
  *log\Debug("booleanArg=" + Str(fromULong(booleanArg)))
  *log\Debug("dwFlags=" + Str(dwFlags))
  *log\Debug("message=" + Utf8ToUnicode(message))
  
  ;native data example
  Define native.l, nativeData.s
  result = FREGetContextNativeData(ctx, @native)
  *log\Debug(ResultDescription(result, "FREGetContextNativeData"))
  nativeData = PeekS(native, -1, #PB_Ascii)
  *log\Debug("FREGetContextNativeData=" + nativeData)
  
  
  Define *params.MessageParameters = AllocateMemory(SizeOf(MessageParameters))
  *params\ctx = ctx
  *params\title = "PureBasic"
  *params\text = Utf8ToUnicode(message)
  *params\dwFlags = dwFlags;
  CreateThread(@ModalMessage(), *params)
  
  ;return Boolean.TRUE
  result = FRENewObjectFromBool(toULong(1), @resultObject)
  *log\Debug(ResultDescription(result, "FRENewObjectFromBool"))
  
  ProcedureReturn resultObject
EndProcedure

;CDecl
ProcedureC contextInitializer(extData.l, ctxType.s, ctx.l, *numFunctions.Long, *functions.Long)
  *log\Debug("create context: " + Str(ctx) + "=" + Utf8ToUnicode(ctxType))
  
  ;exported extension functions count:
  Define size.l = 1 
  
  ;Array of FRENamedFunction:
  Dim f.FRENamedFunction(size - 1)
  
  ;there is no unsigned long type in PB
  setULong(*numFunctions, size)
  
  ;If you want to return a string out of a DLL, the string has to be declared as Global before using it.
  
  ;method name
  f(0)\name = asGlobal("showDialog")
  ;function data example
  f(0)\functionData = asGlobal("showDialog")
  ;function pointer
  f(0)\function = @showDialog()

  *functions\l = @f()
  
  ;some additional data can be stored
  extData = #Null
  
  ;native data example
  Define result.l
  result = FRESetContextNativeData(ctx, asGlobal("FRESetContextNativeData"))
  *log\Debug(ResultDescription(result, "FRESetContextNativeData"))
  
  *log\Debug("create context complete");
EndProcedure 

;CDecl
ProcedureC contextFinalizer(ctx.l)
  *log\Debug("dispose context: " + Str(ctx))
EndProcedure 


;CDecl
ProcedureCDLL initializer(extData.l, *ctxInitializer.Long, *ctxFinalizer.Long)
  *log\Debug("initialize extension")
  extData = #Null
  *ctxInitializer\l = @contextInitializer()
  *ctxFinalizer\l = @contextFinalizer()
  *log\Debug("initialize extension complete")
EndProcedure 

;CDecl
;this method is never called on Windows...
ProcedureCDLL finalizer(extData.l)
  *log\Debug("finalize extension")
EndProcedure 




; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 87
; FirstLine = 105
; Folding = --
; EnableXP