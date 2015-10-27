using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Vebcam
{
    class CommandList
    {
        public static string Get(CommandType type)
        {
            switch (type)
            {
                case CommandType.Information:
                    return "info";
                case CommandType.Video:
                    return "video";
                case CommandType.Foto:
                    return "foto";
                case CommandType.Exit:
                    return "off";
            }
            return null;
        }
    }

    enum CommandType 
    {
        Information,
        Video,
        Foto,
        Exit
    }
}
