namespace Webcam
{
    static class CommandList
    {
        public static string Get(CommandType type)
        {
            switch (type)
            {
                case CommandType.GetInformation:
                    return "info";
                case CommandType.ShootVideo:
                    return "video";
                case CommandType.ShootFoto:
                    return "foto";
                case CommandType.Exit:
                    return "off";
            }
            return null;
        }

        public static CommandType GetCommandType(string command)
        {
            switch (command)
            {
                case "info":
                    return CommandType.GetInformation;
                case "video":
                    return CommandType.ShootVideo;
                case "photo":
                    return CommandType.ShootFoto;
                default:
                    return CommandType.Exit;
            }
        }
    }

    enum CommandType 
    {
        GetInformation,
        ShootVideo,
        ShootFoto,
        Exit
    }
}
