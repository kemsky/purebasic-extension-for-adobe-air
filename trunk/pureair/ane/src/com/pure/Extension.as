package com.pure
{
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;

    import mx.logging.ILogger;
    import mx.logging.Log;

    /**
     * Wrapper for PureBasic extension
     */
    public class Extension
    {
        /**
         * Extension id, must be specified in air-manifest.xml and extension.xml
         */
        public static const CONTEXT:String = "com.pure.Extension";

        private static const log:ILogger = Log.getLogger(CONTEXT);

        /**
         * @private
         */
        private var _context:ExtensionContext;

        /**
         * @private
         */
        private var contextType:String;

        /**
         * Creates context
         * @param contextType default value is "PureAir"
         * @param debugLevel extension debug level:
         * <ul>
         *    <li>#LOG_DEBUG      = 0</li>
         *    <li>#LOG_INFO       = 1</li>
         *    <li>#LOG_WARN       = 2</li>
         *    <li>#LOG_ERROR      = 3</li>
         *    <li>#LOG_DISABLED   = 4</li>
         * </ul>
         */
        public function Extension(contextType:String = "PureAir", debugLevel:int = 4)
        {
            //random type
            this.contextType = contextType + Math.round(Math.random() * 100000);
            try
            {
                log.debug("Creating context: {0}, contextType: {1}", CONTEXT, this.contextType);

                _context = ExtensionContext.createExtensionContext(CONTEXT, this.contextType);

                if (_context == null)
                {
                    //creation failed
                    log.error("Failed to create context: {0}, contextType: {1}", CONTEXT, this.contextType);
                }
                else
                {
                    log.debug("Context was created successfully");

                    //listen for extension events
                    _context.addEventListener(StatusEvent.STATUS, onStatusEvent);

                    //set extension debug level
                    _context.actionScriptData = debugLevel;
                }
            }
            catch(e:Error)
            {
                log.error("Failed to create context: {0}, contextType: {1}, stacktrace: {2}", CONTEXT, this.contextType, e.getStackTrace());
            }
        }

        private function get contextCreated():Boolean
        {
            return _context != null;
        }

        /**
         * Test method, shows YesNoCancel modal dialog
         * @param booleanArg boolean parameter
         * @param flags integer parameter, #PB_MessageRequester_YesNoCancel=3, #MB_APPLMODAL = 0
         * @param message string parameter
         * @return
         */
        public function showDialog(booleanArg:Boolean, flags:int, message:String):Boolean
        {
            if (!contextCreated)
                return false;

            var result:Boolean = false;

            try
            {
                result = _context.call('showDialog', booleanArg, flags, message) as Boolean;
                if (!result)
                {
                    log.error("Invocation error: test({0}, {1}, {2})", booleanArg, flags, message);
                }
            }
            catch (e:Error)
            {
                log.error("Invocation error: test({0}, {1}, {2}), stacktrace: {3}", booleanArg, flags, message, e.getStackTrace());
            }
            return result;
        }

        private function onStatusEvent(event:StatusEvent):void
        {
            log.info("Status event received: contextType={0} level={2}, code={1}", this.contextType, event.code, event.level);
        }

        /**
         * Performs clean-up
         */
        public function dispose():void
        {
            if (_context)
            {
                _context.dispose();
                //clean all references
                _context.removeEventListener(StatusEvent.STATUS, onStatusEvent);
                _context = null;
                log.info("Disposed {0}", this.contextType);
            }
            else
            {
                log.warn("Can not dispose {0}: Context is null", this.contextType);
            }
        }
    }
}
