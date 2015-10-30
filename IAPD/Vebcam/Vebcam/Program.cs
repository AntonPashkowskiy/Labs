using System.IO;
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
                try
                {
                    var camera = new WebCamera();
                    var command = arguments.Length > 1 ? arguments[0] : "";
                    var commandType = CommandList.GetCommandType(command);

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
                catch (CommandParserException exception)
                {
                    Log(exception.Message);
                }
                catch (WebCameraException exception)
                {
                    Log(exception.Message);
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
            var identicalProcess = processesList.FirstOrDefault(p => p.ProcessName == "Webcam");

            if (identicalProcess != null)
            {
                identicalProcess.Kill();
            }
        }

        private static void Log(string message)
        {
            var logFileStream = new FileStream("log.txt", FileMode.OpenOrCreate, FileAccess.Write);

            using (var writer = new StreamWriter(logFileStream))
            {
                writer.WriteLine(message);
            }
        }

        private static void DisplayInformation(WebCameraInformation information)
        {

        }
    }
}
