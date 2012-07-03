EnableExplicit

#AIR_CLASS = "ApolloRuntimeContentWindow"

;-FREResult enumeration
Enumeration
    #FRE_OK                  = 0
    #FRE_NO_SUCH_NAME        = 1
    #FRE_INVALID_OBJECT      = 2
    #FRE_TYPE_MISMATCH       = 3
    #FRE_ACTIONSCRIPT_ERROR  = 4
    #FRE_INVALID_ARGUMENT    = 5
    #FRE_READ_ONLY           = 6
    #FRE_WRONG_THREAD        = 7
    #FRE_ILLEGAL_STATE       = 8
    #FRE_INSUFFICIENT_MEMORY = 9
EndEnumeration

;-FREObjectType enumeration
Enumeration
    #FRE_TYPE_OBJECT         = 0
    #FRE_TYPE_NUMBER         = 1
    #FRE_TYPE_STRING         = 2
    #FRE_TYPE_BYTEARRAY      = 3
    #FRE_TYPE_ARRAY          = 4
    #FRE_TYPE_VECTOR         = 5
    #FRE_TYPE_BITMAPDATA     = 6
	  #FRE_TYPE_BOOLEAN        = 7
	  #FRE_TYPE_NULL           = 8
EndEnumeration  

;typedef void *      FREContext;
;typedef void *      FREObject;

;-FREObjectArray
;used to access method arguments
Structure FREObjectArray
    object.l[0]
EndStructure  
  
;typedef FREObject (*FREFunction)(
;        FREContext ctx,
;		    void*      functionData,
;        uint32_t   argc,
;        FREObject  argv[]
;);
;- FREFunction
Prototype.l FREFunction(ctx.l, funcData.l, argc.l, *argv.FREObjectArray)


;-FRENamedFunction
;used to declare extension functions
Structure FRENamedFunction
    name.l
	  functionData.l
    function.FREFunction
EndStructure


;typedef struct {
;    uint32_t length;
;    uint8_t* bytes;
;    } FREByteArray;
;-FREByteArray
Structure FREByteArray
    length.l
    bytes.a[0]
EndStructure
  
;typedef struct {
;    uint32_t  width;           /* width of the BitmapData bitmap */
;    uint32_t  height;          /* height of the BitmapData bitmap */
;    uint32_t  hasAlpha;        /* if non-zero, pixel format is ARGB32, otherwise pixel format is _RGB32, host endianness */
;    uint32_t  isPremultiplied; /* pixel color values are premultiplied with alpha if non-zero, un-multiplied if zero */
;    uint32_t  lineStride32;    /* line stride in number of 32 bit values, typically the same as width */
;    uint32_t* bits32;          /* pointer to the first 32-bit pixel of the bitmap data */
;} FREBitmapData;
;-FREBitmapData
Structure FREBitmapData
  width.l
  height.l
  hasAlpha.l
  isPremultiplied.l
  lineStride32.l
  bits32.l[0] 
EndStructure

;typedef struct {
;    uint32_t  width;           /* width of the BitmapData bitmap */
;    uint32_t  height;          /* height of the BitmapData bitmap */
;    uint32_t  hasAlpha;        /* if non-zero, pixel format is ARGB32, otherwise pixel format is _RGB32, host endianness */
;    uint32_t  isPremultiplied; /* pixel color values are premultiplied with alpha if non-zero, un-multiplied if zero */
;    uint32_t  lineStride32;    /* line stride in number of 32 bit values, typically the same as width */
;    uint32_t  isInvertedY;     /* if non-zero, last row of pixels starts at bits32, otherwise, first row of pixels starts at bits32. */
;    uint32_t* bits32;          /* pointer to the first 32-bit pixel of the bitmap data */
;} FREBitmapData2;
;-FREBitmapData2
Structure FREBitmapData2
  width.l
  height.l
  hasAlpha.l
  isPremultiplied.l
  lineStride32.l
  isInvertedY.l
  bits32.l[0] 
EndStructure    

ImportC "../lib/FlashRuntimeExtensions.lib"

;returns FRE_OK
;        FRE_WRONG_THREAD
;        FRE_INVALID_ARGUMENT If nativeData is null.
;FREResult FREGetContextNativeData( FREContext ctx, void** nativeData );
;-FREGetContextNativeData
FREGetContextNativeData.l (ctx.l, nativeData.l)

;returns FRE_OK
;FRE_INVALID_ARGUMENT
;FRE_WRONG_THREAD
;FREResult FRESetContextNativeData( FREContext ctx, void* nativeData );
;-FRESetContextNativeData
FRESetContextNativeData.l (ctx.l, nativeData.l)

;returns FRE_OK
;        FRE_WRONG_THREAD
;        FRE_INVALID_ARGUMENT If nativeData is null.
;FREResult FREGetContextActionScriptData( FREContext ctx, FREObject *actionScriptData );
;-FREGetContextActionScriptData
FREGetContextActionScriptData.l (ctx.l, actionScriptData.l)

;returns FRE_OK
;        FRE_WRONG_THREAD
;FREResult FRESetContextActionScriptData( FREContext ctx, FREObject actionScriptData );
;-FRESetContextActionScriptData
FRESetContextActionScriptData.l (ctx.l, actionScriptData.l)

;returns FRE_OK
;        FRE_INVALID_OBJECT
;        FRE_WRONG_THREAD
;        FRE_INVALID_ARGUMENT If objectType is null.
;FREResult FREGetObjectType( FREObject object, FREObjectType *objectType );
;-FREGetObjectType
FREGetObjectType.l (object.l, objectType.l)

;return  FRE_OK
;        FRE_TYPE_MISMATCH
;        FRE_INVALID_OBJECT
;        FRE_INVALID_ARGUMENT
;        FRE_WRONG_THREAD

;FREResult FREGetObjectAsInt32 ( FREObject object, int32_t  *value );
;-FREGetObjectAsInt32
FREGetObjectAsInt32.l  (object.l, value.l)

;FREResult FREGetObjectAsUint32( FREObject object, uint32_t *value );
;-FREGetObjectAsUint32
FREGetObjectAsUint32.l (object.l, value.l)

;FREResult FREGetObjectAsDouble( FREObject object, double   *value );
;-FREGetObjectAsDouble
FREGetObjectAsDouble.l (object.l, value.l)

;FREResult FREGetObjectAsBool  ( FREObject object, uint32_t *value );
;-FREGetObjectAsBool
FREGetObjectAsBool.l   (object.l, value.l)


;return  FRE_OK
;        FRE_INVALID_ARGUMENT
;        FRE_WRONG_THREAD

;FREResult FRENewObjectFromInt32 ( int32_t  value, FREObject *object );
;-FRENewObjectFromInt32
FRENewObjectFromInt32.l  (value.i, object.l)

;FREResult FRENewObjectFromUint32( uint32_t value, FREObject *object );
;-FRENewObjectFromUint32
FRENewObjectFromUint32.l (value.l, object.l)

;FREResult FRENewObjectFromDouble( double   value, FREObject *object );
;-FRENewObjectFromDouble
FRENewObjectFromDouble.l (value.d, object.l)

;FREResult FRENewObjectFromBool  ( uint32_t value, FREObject *object );
;-FRENewObjectFromBool
FRENewObjectFromBool.l   (value.l, object.l)


; Retrieves a string representation of the object referred To by
; the given object. The referenced string is immutable And valid 
; only For duration of the call To a registered function. If the 
; caller wishes To keep the the string, they must keep a copy of it.
; 
; param object The string To be retrieved.
; 
; param length The size, in bytes, of the string. Includes the
;                null terminator.
; 
; param value  A pointer To a possibly temporary copy of the string.
; 
; return  FRE_OK
;          FRE_TYPE_MISMATCH
;          FRE_INVALID_OBJECT
;          FRE_INVALID_ARGUMENT
;          FRE_WRONG_THREAD
;FREResult FREGetObjectAsUTF8(FREObject  object, uint32_t* length, const uint8_t** value);
;-FREGetObjectAsUTF8
FREGetObjectAsUTF8.l (object.l, length.l, value.l)


; Creates a new String object that contains a copy of the specified
; string.
;
; param length The length, in bytes, of the original string. Must include
;               the null terminator.
;
; param value  A pointer To the original string.
;
; param object Receives a reference To the new string object.
; 
; return  FRE_OK
;         FRE_INVALID_ARGUMENT
;         FRE_WRONG_THREAD
;FREResult FRENewObjectFromUTF8(uint32_t length, const uint8_t*  value, FREObject* object);
;-FRENewObjectFromUTF8
FRENewObjectFromUTF8.l (length.l, value.l, object.l)




; param className UTF8-encoded name of the class being constructed.
;
; param thrownException A pointer To a handle that can receive the handle of any ActionScript 
;            Error thrown during execution. May be null If the caller does Not
;            want To receive this handle. If Not null And no error occurs, is set an
;            invalid handle value.
;
; return  FRE_OK
;         FRE_TYPE_MISMATCH
;         FRE_INVALID_OBJECT
;         FRE_INVALID_ARGUMENT
;         FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from calling this method.
;              In this Case, thrownException will be set To the handle of the thrown value. 
;         FRE_ILLEGAL_STATE If a ByteArray Or BitmapData has been acquired And Not yet released.
;         FRE_NO_SUCH_NAME
;         FRE_WRONG_THREAD
;FREResult FRENewObject(const uint8_t* className, uint32_t argc, FREObject argv[], FREObject* object, FREObject* thrownException);
;-FRENewObject
FRENewObject.l (className.l, argc.l, argv.l , object.l, thrownException.l)


; @param propertyName UTF8-encoded name of the property being fetched.
;
; @param thrownException A pointer To a handle that can receive the handle of any ActionScript 
;            Error thrown during getting the property. May be null If the caller does Not
;            want To receive this handle. If Not null And no error occurs, is set an
;            invalid handle value.
;
; @return  FRE_OK
;          FRE_TYPE_MISMATCH
;          FRE_INVALID_OBJECT
;          FRE_INVALID_ARGUMENT
;
;          FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from getting this property.
;              In this Case, thrownException will be set To the handle of the thrown value. 
;
;          FRE_NO_SUCH_NAME If the named property doesn't exist, or if the reference is ambiguous
;              because the property exists in more than one namespace.
;
;          FRE_ILLEGAL_STATE If a ByteArray Or BitmapData has been acquired And Not yet released.
;
;          FRE_WRONG_THREAD
;FREResult FREGetObjectProperty(FREObject object, const uint8_t*  propertyName, FREObject* propertyValue, FREObject* thrownException);
;-FREGetObjectProperty
FREGetObjectProperty.l (object.l, propertyName.l, propertyValue.l, thrownException.l)


;  param propertyName UTF8-encoded name of the property being set.
;
;  param thrownException A pointer To a handle that can receive the handle of any ActionScript 
;            Error thrown during method execution. May be null If the caller does Not
;            want To receive this handle. If Not null And no error occurs, is set an
;            invalid handle value.
;
;
;  return  FRE_OK
;          FRE_TYPE_MISMATCH
;          FRE_INVALID_OBJECT
;          FRE_INVALID_ARGUMENT
;          FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from getting this property.
;              In this Case, thrownException will be set To the handle of the thrown value. 
;
;          FRE_NO_SUCH_NAME If the named property doesn't exist, or if the reference is ambiguous
;              because the property exists in more than one namespace.
;
;          FRE_ILLEGAL_STATE If a ByteArray Or BitmapData has been acquired And Not yet released.
;
;          FRE_READ_ONLY
;          FRE_WRONG_THREAD
;FREResult FRESetObjectProperty(FREObject object, const uint8_t* propertyName, FREObject propertyValue, FREObject* thrownException);
;-FRESetObjectProperty
FRESetObjectProperty.l (object.l, propertyName.l, propertyValue.l, thrownException.l)


; param methodName UTF8-encoded null-terminated name of the method being invoked.
;
; param thrownException A pointer To a handle that can receive the handle of any ActionScript 
;            Error thrown during method execution. May be null If the caller does Not
;            want To receive this handle. If Not null And no error occurs, is set an
;            invalid handle value.
;
; return  FRE_OK
;         FRE_TYPE_MISMATCH
;         FRE_INVALID_OBJECT
;         FRE_INVALID_ARGUMENT
;         FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from calling this method.
;              In this Case, thrownException will be set To the handle of the thrown value. 
;
;         FRE_NO_SUCH_NAME If the named method doesn't exist, or if the reference is ambiguous
;              because the method exists in more than one namespace.
;
;         FRE_ILLEGAL_STATE If a ByteArray Or BitmapData has been acquired And Not yet released.
;
;         FRE_WRONG_THREAD
;FREResult FRECallObjectMethod (FREObject object, const uint8_t* methodName, uint32_t argc, FREObject argv[], FREObject* result, FREObject* thrownException);
;-FRECallObjectMethod
FRECallObjectMethod.l (object.l, methodName.l, argc.l, argv.l, result.l, thrownException.l)


; Referenced Data is valid only For duration of the call
; To a registered function.
;
; return  FRE_OK
;         FRE_TYPE_MISMATCH
;         FRE_INVALID_OBJECT
;         FRE_INVALID_ARGUMENT
;         FRE_WRONG_THREAD
;         FRE_ILLEGAL_STATE
;FREResult FREAcquireBitmapData(FREObject object, FREBitmapData* descriptorToSet);
;-FREAcquireBitmapData
FREAcquireBitmapData.l (object.l, descriptorToSet.l)

;  Referenced Data is valid only For duration of the call
;  To a registered function.
; 
;  Use of this API requires that the extension And application must be packaged For 
;  the 3.1 namespace Or later.
; 
;   return  FRE_OK
;           FRE_TYPE_MISMATCH
;           FRE_INVALID_OBJECT
;           FRE_INVALID_ARGUMENT
;           FRE_WRONG_THREAD
;           FRE_ILLEGAL_STATE
;FREResult FREAcquireBitmapData2(FREObject object, FREBitmapData2* descriptorToSet);
;-FREAcquireBitmapData2
FREAcquireBitmapData2.l (object.l, descriptorToSet.l)


; BitmapData must be acquired To call this. Clients must invalidate any region
; they modify in order To notify AIR of the changes. Only invalidated regions
; are redrawn.
;
; return  FRE_OK
;         FRE_INVALID_OBJECT
;         FRE_WRONG_THREAD
;         FRE_ILLEGAL_STATE
;         FRE_TYPE_MISMATCH
;FREResult FREInvalidateBitmapDataRect(FREObject object, uint32_t x, uint32_t y, uint32_t width, uint32_t height);
;-FREInvalidateBitmapDataRect
FREInvalidateBitmapDataRect.l (object.l, x.l, y.l, width.l, height.l)
        

;  return  FRE_OK
;          FRE_WRONG_THREAD
;          FRE_ILLEGAL_STATE
;          FRE_TYPE_MISMATCH
;FREResult FREReleaseBitmapData( FREObject object );
;-FREReleaseBitmapData
FREReleaseBitmapData.l (object.l)


; Referenced Data is valid only For duration of the call
;  To a registered function.
; 
; return  FRE_OK
;         FRE_TYPE_MISMATCH
;         FRE_INVALID_OBJECT
;         FRE_WRONG_THREAD
;


; Referenced Data is valid only For duration of the call
; To a registered function.
;
; return  FRE_OK
;         FRE_TYPE_MISMATCH
;         FRE_INVALID_OBJECT
;         FRE_INVALID_ARGUMENT
;         FRE_WRONG_THREAD
;         FRE_ILLEGAL_STATE
;FREResult FREAcquireByteArray(FREObject object, FREByteArray* byteArrayToSet);
;-FREAcquireByteArray
FREAcquireByteArray.l (object.l, byteArrayToSet.l)

; return  FRE_OK
;         FRE_INVALID_OBJECT
;         FRE_ILLEGAL_STATE
;         FRE_WRONG_THREAD
;FREResult FREReleaseByteArray( FREObject object );
;-FREReleaseByteArray
FREReleaseByteArray.l (object.l)


; return  FRE_OK
;         FRE_INVALID_OBJECT
;         FRE_INVALID_ARGUMENT
;         FRE_ILLEGAL_STATE
;         FRE_TYPE_MISMATCH
;         FRE_WRONG_THREAD
;FREResult FREGetArrayLength(FREObject arrayOrVector, uint32_t* length);
;-FREGetArrayLength
FREGetArrayLength.l (arrayOrVector.l, length.l)


; return  FRE_OK
;         FRE_INVALID_OBJECT
;         FRE_TYPE_MISMATCH
;         FRE_ILLEGAL_STATE
;         FRE_INVALID_ARGUMENT If length is greater than 2^32.
;
;         FRE_READ_ONLY   If the handle refers To a Vector
;               of fixed size.
; 
;         FRE_WRONG_THREAD
;         FRE_INSUFFICIENT_MEMORY
;FREResult FRESetArrayLength(FREObject arrayOrVector, uint32_t length);
;-FRESetArrayLength
FRESetArrayLength.l (arrayOrVector.l, length.l)

; If an Array is sparse And an element that isn't defined is requested, the
; Return value will be FRE_OK but the handle value will be invalid.
;
; Return  FRE_OK
;         FRE_ILLEGAL_STATE
;
;         FRE_INVALID_ARGUMENT If the handle refers To a vector And the index is
;             greater than the size of the Array.
;
;         FRE_INVALID_OBJECT
;         FRE_TYPE_MISMATCH
;         FRE_WRONG_THREAD
;FREResult FREGetArrayElementAt(FREObject arrayOrVector, uint32_t index, FREObject* value);
;-FREGetArrayElementAt
FREGetArrayElementAt.l (arrayOrVector.l, index.l, value.l)

; return  FRE_OK
;         FRE_INVALID_OBJECT
;         FRE_ILLEGAL_STATE
;
;         FRE_TYPE_MISMATCH If an attempt To made To set a value in a Vector
;              when the type of the value doesn't match the Vector's item type.
;
;         FRE_WRONG_THREAD
;FREResult FRESetArrayElementAt(FREObject arrayOrVector, uint32_t index, FREObject value);
;-FRESetArrayElementAt
FRESetArrayElementAt.l (arrayOrVector.l, index.l, value.l)


; Causes a StatusEvent To be dispatched from the associated
; ExtensionContext object.
;
; Dispatch happens asynchronously, even If this is called during
; a call To a registered function.
;
; The ActionScript portion of this extension can listen For that event
; And, upon receipt, query the native portion For details of the event
; that occurred.
;
; This call is thread-safe And may be invoked from any thread. The string
; values are copied before the call returns.
;
; @return  FRE_OK In all circumstances, As the referenced object cannot
;              necessarily be checked For validity on the invoking thread.
;              However, no event will be dispatched If the object is
;              invalid Or Not an EventDispatcher.
;          FRE_INVALID_ARGUMENT If code Or level is NULL
;FREResult FREDispatchStatusEventAsync(FREContext ctx, const uint8_t* code, const uint8_t* level);
;-FREDispatchStatusEventAsync
FREDispatchStatusEventAsync.l (ctx.l, code.l, level.l)

EndImport

Procedure.s ResultDescription(result.l, fname.s)
  Define message.s
  
  Select result
    Case #FRE_OK   
      message = "#FRE_OK"
    Case #FRE_NO_SUCH_NAME  
      message = "#FRE_NO_SUCH_NAME"
    Case #FRE_INVALID_OBJECT
      message = "#FRE_INVALID_OBJECT"
    Case #FRE_TYPE_MISMATCH  
      message = "#FRE_TYPE_MISMATCH"
    Case #FRE_ACTIONSCRIPT_ERROR 
      message = "#FRE_ACTIONSCRIPT_ERROR"
    Case #FRE_INVALID_ARGUMENT   
      message = "#FRE_INVALID_ARGUMENT"
    Case #FRE_READ_ONLY          
      message = "#FRE_READ_ONLY"
    Case #FRE_WRONG_THREAD      
      message = "#FRE_WRONG_THREAD"
    Case #FRE_ILLEGAL_STATE     
      message = "#FRE_ILLEGAL_STATE"
    Case #FRE_INSUFFICIENT_MEMORY 
      message = "#FRE_INSUFFICIENT_MEMORY"
    Default
      message = "unknown result(" + Str(result) + ")"
  EndSelect
  ProcedureReturn "Function (" + fname + ") result " + message
EndProcedure

Procedure.s TypeDescription(result.l)
  Define message.s
  
  Select result
    Case #FRE_TYPE_OBJECT   
      message = "#FRE_TYPE_OBJECT"
    Case #FRE_TYPE_NUMBER  
      message = "#FRE_TYPE_NUMBER"
    Case #FRE_TYPE_STRING
      message = "#FRE_TYPE_STRING"
    Case #FRE_TYPE_BYTEARRAY  
      message = "#FRE_TYPE_BYTEARRAY"
    Case #FRE_TYPE_ARRAY 
      message = "#FRE_TYPE_ARRAY"
    Case #FRE_TYPE_VECTOR   
      message = "#FRE_TYPE_VECTOR"
    Case #FRE_TYPE_BITMAPDATA          
      message = "#FRE_TYPE_BITMAPDATA"
    Case #FRE_TYPE_BOOLEAN      
      message = "#FRE_TYPE_BOOLEAN"
    Case #FRE_TYPE_NULL     
      message = "#FRE_TYPE_NULL"
    Default
      message = "unknown type(" + Str(result) + ")"
  EndSelect
  ProcedureReturn message
EndProcedure
 
 

; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 520
; FirstLine = 479
; Folding = -
; EnableXP