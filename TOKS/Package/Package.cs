using System;
using System.Collections.Generic;
using System.Linq;

namespace Packages
{
    public class Package
    {
        private const byte _startByte = 126;
        private const byte _escapeByte = 125;
        private const byte _startByteDeterminant = 94;
        private const byte _escapeByteDeterminant = 93;

        private byte[] _data;

        public Package(byte[] data)
        {
            Data = data;
        }

        public byte[] Data
        {
            get
            {
                return _data;
            }
            set
            {
                if(value != null)
                {
                    _data = EncodeBytes(value);
                }
            }
        }

        public static byte[] DecodeBytes(byte[] data)
        {
            if(data[0] != _startByte)
            {
                throw new ArgumentException("Invalid data. No start byte.");
            }

            List<byte> listOfBytes = data.ToList();
            listOfBytes.RemoveAt(0);

            for (int i = 0; i < listOfBytes.Count; i++)
			{
                if(listOfBytes[i] == _escapeByte)
                {
                    if (listOfBytes[i + 1] == _startByteDeterminant)
                    {
                        listOfBytes[i] = _startByte;
                    }
                    listOfBytes.RemoveAt(i + 1);
                }
                else if(listOfBytes[i] == _startByte)
                {
                    listOfBytes.RemoveAt(i);
                }
			}

            return listOfBytes.ToArray();
        }

        private byte[] EncodeBytes(byte[] data)
        {
            List<byte> listOfBytes = data.ToList();

            listOfBytes.Insert(0, _startByte);

            for (int i = 1; i < listOfBytes.Count; i++)
            {
                if (listOfBytes[i] == _startByte)
                {
                    listOfBytes[i] = _escapeByte;
                    InsertItemToList(listOfBytes, _startByteDeterminant, i + 1);
                }
                else if (listOfBytes[i] == _escapeByte)
                {
                    InsertItemToList(listOfBytes, _escapeByteDeterminant, i + 1);
                }
            }

            return listOfBytes.ToArray();
        }

        private void InsertItemToList(List<byte> listOfBytes, byte item, int index)
        {
            if (listOfBytes.Count == index)
            {
                listOfBytes.Add(item);
            }
            else if (index >= 0 && index < listOfBytes.Count)
            {
                listOfBytes.Insert(index, item);
            }
        }
    }
}
