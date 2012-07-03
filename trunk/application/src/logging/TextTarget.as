package logging
{
    import mx.formatters.DateFormatter;
    import mx.logging.AbstractTarget;
    import mx.logging.ILogger;
    import mx.logging.LogEvent;

    import spark.components.TextArea;

    public class TextTarget extends AbstractTarget
    {
        private static const SEPARATOR:String = " ";
        private static const DATE_TIME_FORMAT:String = "JJ:NN:SS.";

        private var dateFormatter:DateFormatter = new DateFormatter();

        private var output:TextArea = null;

        public function TextTarget(output:TextArea)
        {
            dateFormatter.formatString = DATE_TIME_FORMAT;
            this.output = output;
        }

        override public function logEvent(event:LogEvent):void
        {
            if (output)
            {
                var d:Date = new Date();
                var date:String = dateFormatter.format(d) + formatTime(d.getMilliseconds()) + SEPARATOR;
                var level:String = "[" + LogEvent.getLevelString(event.level) + "]" + SEPARATOR;
                var category:String = ILogger(event.target).category + SEPARATOR;
                var msg:String = date + level + category + event.message;
                var formatted:String = applyColor(msg, event.level);
                output.text += formatted + "\n";
                output.callLater(output.callLater, [scrollDown, []]);
            }
        }

        private function scrollDown():void
        {
//            output.verticalScrollPosition = output.maxVerticalScrollPosition;
        }

        private function applyColor(msg:String, level:int):String
        {
//            switch (level)
//            {
//                case LogEventLevel.ERROR:
//                    return "<font color='#FF0000'>" + msg + "</font>";
//                case LogEventLevel.WARN:
//                    return "<font color='#0000FF'>" + msg + "</font>";
//                case LogEventLevel.DEBUG:
//                    return "<font color='#BBBBBB'>" + msg + "</font>";
//            }
            return msg;
        }

        private function formatTime(num:Number):String
        {
            if (num < 10)
            {
                return "00" + num.toString();
            }
            else if (num < 100)
            {
                return "0" + num.toString();
            }
            else
            {
                return num.toString();
            }
        }
    }
}
