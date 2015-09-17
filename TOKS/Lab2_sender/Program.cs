using System;
using System.IO.Ports;
using System.Threading;
using Packages;
using CustomExtentions;

namespace Lab2_sender
{
    class Program
    {
        static void Main(string[] args)
        {
            var comPort1 = new SerialPort("COM1", 9600, Parity.None, 8, StopBits.One);

            comPort1.Open();

            while (true)
            {
                Console.Write("Enter message: ");
                string message = Console.ReadLine();

                SendData(comPort1, message.ToBytes());

                Console.Write("Exit? [Y - yes, N - no]: ");
                var keyInfo = Console.ReadKey();

                if (keyInfo.Key == ConsoleKey.Y)
                {
                    break;
                }
                Console.WriteLine();
            }
            Console.Clear();
            comPort1.Close();
            Console.ReadKey();
        }

        private static void SendData(SerialPort serialPort, byte[] data)
        {
            if (data == null || data.Length == 0)
            {
                return;
            }

            Package[] packages = data.ToPackages();

            for (int i = 0; i < packages.Length; i++)
            {
                serialPort.RtsEnable = true;
                serialPort.WriteTimeout = 200;
                serialPort.Write(packages[i].Data, 0, packages[i].Data.Length);
                serialPort.RtsEnable = false;
                Thread.Sleep(100);
            }
        }
    }
}
