using System;
using System.IO.Ports;
using System.Threading;
using Packages;
using CustomExtentions;

namespace Lab2_reciever
{
    class Program
    {
        static void Main(string[] args)
        {
            var comPort2 = new SerialPort("COM2", 9600, Parity.None, 8, StopBits.One);
            
            comPort2.DataReceived += RecieveData;
            comPort2.ErrorReceived += ErrorRecieved;

            comPort2.Open();
            Thread.Sleep(Timeout.Infinite);
        }

        private static void RecieveData(object sender, SerialDataReceivedEventArgs e)
        {
            SerialPort serialPort = sender as SerialPort;

            if (serialPort != null && serialPort.BytesToRead != 0)
            {
                string data = serialPort.ReadExisting();

                byte[] bytes = data.ToBytes();
                data = Package.DecodeBytes(bytes).DecodeToString();

                if (data == "exit")
                {
                    Environment.Exit(0);
                }
                Console.WriteLine("\nReciever {0}: {1}", serialPort.PortName, data);
            }
        }

        private static void ErrorRecieved(object sender, SerialErrorReceivedEventArgs e)
        {
            SerialPort serialPort = sender as SerialPort;

            if (serialPort != null)
            {
                Console.WriteLine("Error recieved. Port name: {0}.", serialPort.PortName);
            }
        }
    }
}
