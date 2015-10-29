namespace Webcam
{
    class CommandList
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
    }

    enum CommandType 
    {
        GetInformation,
        ShootVideo,
        ShootFoto,
        Exit
    }
}
