using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Windows.Forms;
using System.Threading;
using System.Runtime.InteropServices;
using System.Reflection;

namespace Vebcam
{
    class Program
    {
        private static Mutex applicationMutex = null;

        static void Main(string[] args)
        {
            bool isMainApplication = TryTakeMutex();

            if (isMainApplication)
            {
                Application.ApplicationExit += ApplicationExitHandler;
                Thread.Sleep(100000);
            }
            else if (args.Length > 0 && args[0] == CommandList.Get(CommandType.Exit))
            {
                KillIdenticalProcess();
            }
        }

        private static bool TryTakeMutex()
        {
            bool createdNew;
            string applicationGuid = Marshal.GetTypeLibGuidForAssembly(Assembly.GetExecutingAssembly()).ToString();
            applicationMutex = new Mutex(true, applicationGuid, out createdNew);

            return createdNew;
        }

        private static void KillIdenticalProcess()
        {
            var processesList = Process.GetProcesses();
            var identicalProcess =  processesList.FirstOrDefault(p => p.ProcessName == "Vebcam");

            if (identicalProcess != null)
            {
                identicalProcess.Kill();
            }
        }

        private static void ApplicationExitHandler(object sender, EventArgs e)
        {
            using (var file = new StreamWriter(new FileStream("hello.txt", FileMode.OpenOrCreate)))
            {
                file.WriteLine("follow the white rabbit.");
            }
        }
    }
}
