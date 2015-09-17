using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Packages
{
    public static class BytesExtentions
    {
        private const int _packageLength = 16;

        public static Package[] ToPackages(this byte[] data)
        {
            List<Package> result = new List<Package>();
            int countOfPackages = data.Length / 16 + 1;
            
            for (int i = 0; i < countOfPackages; i++)
            {
                byte[] bitOfData = data
                    .Skip(i * _packageLength)
                    .Take(_packageLength)
                    .ToArray();

                result.Add(new Package(bitOfData));   
            }

            return result.ToArray();
        }
    }
}
