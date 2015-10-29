using System;
using System.Runtime.Serialization;

namespace WebcamLib
{
    [Serializable]
    public class WebCameraException : Exception
    {
        public WebCameraException()
        {
        }

        public WebCameraException(string message) : base(message)
        {
        }

        public WebCameraException(string message, Exception inner) : base(message, inner)
        {
        }

        protected WebCameraException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}
