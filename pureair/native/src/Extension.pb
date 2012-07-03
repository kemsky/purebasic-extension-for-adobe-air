EnableExplicit

;#LOG_FILE = "C:\pureair.log"

XIncludeFile "Unsigned.pb"
XIncludeFile "Unicode.pb"
XIncludeFile "Logger.pb"
XIncludeFile "FlashRuntimeExtensions.pb"

Global *log.Logger

Global hInst.l
Global mainHWND.l
Global processID.l


Structure MessageParameters
  text.s
  title.s
  dwFlags.l
  ctx.l
EndStructure

ProcedureDLL AttachProcess(Instance)
  ;- This procedure is called once, when the program loads the library
  ;  for the first time. All init stuffs can be done here (but not DirectX init)
  hInst = Instance
  processID = GetCurrentProcessId_()
  
  LOG_LEVEL = #LOG_DEBUG
  
  *log = New_Logger("pureair.dll")
  
  *log\info(#CRLF$)
  *log\info(#CRLF$)
  *log\info("----------------------------------------------------------------")
  *log\info("AttachProcess: " + Str(processID) + ", instance = " + Str(hInst))
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

Procedure EnumWindows(hWnd.l, *lParam.Long)
  Define windowProcessId.l
  GetWindowThreadProcessId_(hWnd, @windowProcessId)
  
  If (processID = windowProcessId)
    Define ClassName.s{255}
    GetClassName_(hWnd, @ClassName, 255)
    
    If (#AIR_CLASS= ClassName)
      Define Title.s{255}
      GetWindowText_(hWnd, @Title, 255)
      *log\info("Found Air Window: hwnd=" + Str(hWnd) + ", ClassName=" + ClassName + ", Title=" + Title)
      mainHWND = hWnd
      *lParam\l = hWnd
      ProcedureReturn #False
    EndIf
  EndIf
 
  ProcedureReturn #True
EndProcedure

Procedure LogError()
   Define error.l
   error = GetLastError_()
   If error
      Define *Memory, length.l, err_msg$
      *Memory = AllocateMemory(255)
      length = FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM, #Null, error, 0, *Memory, 255, #Null)
      If length > 1 ; Some error messages are "" + Chr (13) + Chr (10)... stoopid M$... :(
         err_msg$ = PeekS(*Memory, length - 2)
      Else
      err_msg$ = "Unknown error!"
      EndIf
      FreeMemory(*Memory)
      *log\error(err_msg$)
   EndIf
EndProcedure 


Procedure ModalMessage(*params.MessageParameters)
  Define result.l, code.l
  code = MessageRequester(*params\title, *params\text, *params\dwFlags)
  result = FREDispatchStatusEventAsync(*params\ctx, asGlobal("closed"), asGlobal(Str(code)))
  *log\Debug (ResultDescription(result, "FREDispatchStatusEventAsync"))
EndProcedure



ProcedureC.l showDialog(ctx.l, funcData.l, argc.l, *argv.FREObjectArray)
  *log\Debug("showDialog")
  
  Define fd.s
  fd = PeekS(funcData, -1, #PB_Ascii)
  *log\Debug("funcData=" + fd)
  
  *log\Debug("arg size: " + Str(fromULong(argc)))

  Define result.l, resultObject.l, length.l, arg1.l, dwFlags.l, arg3.s, *string.Ascii
  
  result = FREGetObjectAsBool(*argv\object[0], @arg1)
  *log\Debug("result=" + ResultDescription(result, "FREGetObjectAsBool") + ", arg1=" + Str(fromULong(arg1)))
  
  result = FREGetObjectAsInt32(*argv\object[1], @dwFlags)
  *log\Debug("result=" + ResultDescription(result, "FREGetObjectAsInt32") + ", dwFlags=" + Str(dwFlags))
  
  length = 1000
  result = FREGetObjectAsUTF8(*argv\object[2], @length, @*string)
  *log\Debug("result=" + ResultDescription(result, "FREGetObjectAsUTF8"))
  *log\Debug("length=" + Str(fromULong(length)))
  arg3 = PeekS(*string, fromULong(length) + 1)
  *log\Debug("arg3=" + Utf8ToUnicode(arg3))
  
  Define native.l
  result = FREGetContextNativeData(ctx, @native)
  fd = PeekS(native, -1, #PB_Ascii)
  *log\Debug("FREGetContextNativeData=" + fd)
  *log\Debug(ResultDescription(result, "FRENewObjectFromBool"))
  
  Define hwnd.l
  EnumWindows_(@EnumWindows(), @hwnd)
  
  
  Define *params.MessageParameters = AllocateMemory(SizeOf(MessageParameters))
  *params\ctx = ctx
  *params\title = "PureBasic"
  *params\text = Utf8ToUnicode(arg3)
  *params\dwFlags = dwFlags;
  CreateThread(@ModalMessage(), *params)
  
  
  *log\info("hwnd=" + Str(hwnd))
  
  *log\Debug("test method ok")
  
  result = FRENewObjectFromBool(toULong(1), @resultObject)
  *log\Debug(ResultDescription(result, "FRENewObjectFromBool"))
  
  ProcedureReturn resultObject
EndProcedure


ProcedureC contextInitializer(extData.l, ctxType.s, ctx.l, *numFunctions.Long, *functions.Long)
  *log\Debug("create context: " + Str(ctx) + "=" + Utf8ToUnicode(ctxType))
  
  Define c.s = "тест"
  *log\Debug (c)
  *log\Debug("unicode: " + Utf8ToUnicode(c))
  
  Define size.l = 1
  Dim f.FRENamedFunction(size - 1)
  
  setULong(*numFunctions, size)

  f(0)\name = asGlobal("showDialog")
  f(0)\functionData = asGlobal("showDialog")
  f(0)\function = @showDialog()

  *functions\l = @f()
  
  extData = #Null
  
  Define result.l, fre.s
  fre = "FRESetContextNativeDataТест"
  result = FRESetContextNativeData(ctx, asGlobal(fre))
  *log\Debug(ResultDescription(result, "FRENewObjectFromBool"))
  
  *log\Debug("create context complete");
EndProcedure 


ProcedureC contextFinalizer(ctx.l)
  *log\Debug("dispose context: " + Str(ctx))
EndProcedure 


ProcedureCDLL initializer(extData.l, *ctxInitializer.Long, *ctxFinalizer.Long)
  *log\Debug("initialize extension")
  extData = #Null
  *ctxInitializer\l = @contextInitializer()
  *ctxFinalizer\l = @contextFinalizer()
  *log\Debug("initialize extension complete")
EndProcedure 


ProcedureCDLL finalizer(extData.l)
  *log\Debug("finalize extension")
EndProcedure 




; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 142
; FirstLine = 102
; Folding = ---
; EnableXP