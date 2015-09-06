using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TOKSLab1
{
	class Program
	{
        private const int maxBaudRate = 115200;

		public static void Main(string[] args)
		{
            var comPort1 = new SerialPort("COM1", 9600, Parity.None, 8, StopBits.One);
            var comPort2 = new SerialPort("COM2", 8600, Parity.None, 8, StopBits.One);

            comPort1.DataReceived += RecieveData;
            comPort1.ErrorReceived += ErrorRecieved;
            comPort2.DataReceived += RecieveData;
            comPort2.ErrorReceived += ErrorRecieved;

            comPort1.Open();
            comPort2.Open();

            while (true)
            {
                Console.Write("Choose port [COM1 - 1, COM2 - 2]: ");
                string portNumberString = Console.ReadLine();
                int portNumber;
                bool success = int.TryParse(portNumberString, out portNumber);

                if (success && (portNumber == 1 || portNumber == 2))
                {
                    Console.Write("Enter message: ");
                    string message = Console.ReadLine();

                    //SetMaxSpeed(comPort1, comPort2);
                    var portForSending = portNumber == 1 ? comPort1 : comPort2;
                    SendData(portForSending, message.ToBytes());

                    Console.Write("Exit? [Y - yes, N - no]: ");
                    var keyInfo = Console.ReadKey();

                    if (keyInfo.Key == ConsoleKey.Y)
                    {
                        break;
                    }
                }
                else
                {
                    Console.WriteLine("Input error.");
                }
                Console.Clear();
            }

            comPort1.Close();
            comPort2.Close();
            Console.ReadKey();
		}

        private static void SetMaxSpeed(SerialPort port1, SerialPort port2)
        {
            port1.BaudRate = maxBaudRate;
            port2.BaudRate = maxBaudRate;
        }

        private static void SendData(SerialPort serialPort, byte[] data)
        {
            if (data != null)
            {
                serialPort.RtsEnable = true;
                serialPort.WriteTimeout = 200;
                serialPort.Write(data, 0, data.Length);
                serialPort.RtsEnable = false;
            }
        }

        private static void RecieveData(object sender, SerialDataReceivedEventArgs e)
        {
            SerialPort serialPort = sender as SerialPort;

            if (serialPort != null && serialPort.BytesToRead != 0)
	        {
                string data = serialPort.ReadExisting();
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
