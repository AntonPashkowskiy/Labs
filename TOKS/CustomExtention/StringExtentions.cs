using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CustomExtentions
{
    public static class StringExtentions
    {
        public static byte[] ToBytes(this string targetString)
        {
            return Encoding.Default.GetBytes(targetString);
        }

        public static string DecodeToString(this byte[] bytes)
        {
            return Encoding.Default.GetString(bytes);
        }
    }
}
