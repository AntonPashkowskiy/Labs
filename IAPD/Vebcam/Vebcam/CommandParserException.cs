using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Webcam
{
    [Serializable]
    public class CommandParserException : Exception
    {
        public CommandParserException()
        {
        }

        public CommandParserException(string message) : base(message)
        {
        }

        public CommandParserException(string message, Exception inner) : base(message, inner)
        {
        }

        protected CommandParserException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }   
}
