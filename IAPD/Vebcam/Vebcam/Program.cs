using System.Linq;
using System.Diagnostics;
using System.Threading;
using System.Runtime.InteropServices;
using System.Reflection;
using WebcamLib;

namespace Webcam
{
    class Program
    {
        public static Mutex ApplicationMutex { get; set; }

        static void Main(string[] arguments)
        {
            if (IsMainApplication())
            {
                var camera = new WebCamera();
                var commandType = CommandParser.GetCommandType(arguments);

                switch (commandType)
                {
                    case CommandType.GetInformation:
                        var webCamerainformation = camera.GetInformation();
                        DisplayInformation(webCamerainformation);
                        break;
                    case CommandType.ShootFoto:
                        var photoShootingSetting = CommandParser.Parse(arguments);
                        camera.ShootPhoto(photoShootingSetting);
                        break;
                    case CommandType.ShootVideo:
                        var videoShootingSetting = CommandParser.Parse(arguments);
                        camera.ShootVideo(videoShootingSetting);
                        break;
                    case CommandType.Exit:
                        return;
                }
            }
            else if (arguments.Length > 0 && arguments[0] == CommandList.Get(CommandType.Exit))
            {
                KillIdenticalProcess();
            }
        }

        private static bool IsMainApplication()
        {
            bool createdNew;
            string applicationGuid = Marshal.GetTypeLibGuidForAssembly(Assembly.GetExecutingAssembly()).ToString();
            ApplicationMutex = new Mutex(true, applicationGuid, out createdNew);

            return createdNew;
        }

        private static void KillIdenticalProcess()
        {
            var processesList = Process.GetProcesses();
            var identicalProcess =  processesList.FirstOrDefault(p => p.ProcessName == "Webcam");

            if (identicalProcess != null)
            {
                identicalProcess.Kill();
            }
        }

        private static void DisplayInformation(WebCameraInformation information)
        {
            
        }
    }
}
