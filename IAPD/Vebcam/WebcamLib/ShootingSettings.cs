namespace WebcamLib
{
    public struct ShootingSettings
    {
        private int _videoWidth;
        private int _videoHeight;
        private int _frameRate;

        public string SavingPath { get; set; }

        /*public int VideoWidth
        {
            get { return _videoWidth; }
            set
            {
                _videoWidth = value >= 0 ? value : 0; 
            }
        }

        public int VideoHeight
        {
            get { return _videoHeight; }
            set
            {
                _videoHeight = value >= 0 ? value : 0;
            }
        }*/

        public int FrameRate
        {
            get { return _frameRate; }
            set
            {
                _frameRate = value >= 0 ? value : 25;
            }
        }
    }
}
