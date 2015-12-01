using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Windows;
using System.Windows.Forms;
using System.Windows.Interop;
using System.Windows.Media.Imaging;
using System.Windows.Media.Imaging;
using AForge.Video;
using WebcamLib;


namespace WebcamGUI
{
    public partial class MainWindow : Window
    {
        private bool isHided;
        private WebCamera webCamera;
        private PictureBox pictureBox;

        public MainWindow()
        {
            InitializeComponent();
            InitializeCustomComponents();
            InitializeWebCamera();
        }

        private void InitializeWebCamera()
        {
            webCamera = new WebCamera();
            webCamera.NewFrame += OnNewFrameRecieved;
            var webCameraInforamtion = webCamera.GetInformation();
            webCameraNameLabel.Content = webCameraInforamtion.Name;
        }

        private void InitializeCustomComponents()
        {
            pictureBox = new PictureBox();
            pictureBox.Width = (int)windowsFormsHost.Width;
            pictureBox.Height = (int)windowsFormsHost.Height;
            pictureBox.Dock = DockStyle.Fill;
            windowsFormsHost.Child = pictureBox;
        }

        private void OnNewFrameRecieved(object sender, NewFrameEventArgs eventArgs)
        {
            var inputFrame = (Bitmap)eventArgs.Frame.Clone();
            pictureBox.Image = inputFrame;
        }

        public void ToggleWindow()
        {
            if (isHided)
            {
                this.Show();
            }
            else
            {
                this.Hide();
            }
            isHided = !isHided;
        }

        private void OnStartStopButtonClick(object sender, RoutedEventArgs e)
        {
            if (webCamera.CameraIsOn)
            {
                webCamera.StopShootVideo();
            }
            else
            {
                var savingPath = GetSavingPath();
                var shootingSettings = new ShootingSettings()
                {
                    SavingPath = savingPath,
                    FrameRate = 15
                };

                webCamera.StartShootVideo(shootingSettings);
            }
        }

        private void OnSnapshootButtonClick(object sender, RoutedEventArgs e)
        {
            string savingPath = GetSavingPath(true);
            webCamera.ShootPhoto(new ShootingSettings() { SavingPath = savingPath });
        }

        private string GetSavingPath(bool pathForPhoto = false)
        {
            string rootDirectoryName = pathForPhoto ? "Photo" : "Video";
            string fileName = Guid.NewGuid().ToString();
            string fileExtention = pathForPhoto ? ".png" : ".avi";

            if(!Directory.Exists(rootDirectoryName))
            {
                Directory.CreateDirectory(rootDirectoryName);
            }

            string filePath = Path.Combine(rootDirectoryName, fileName);
            return Path.ChangeExtension(filePath, fileExtention);
        }
    }
}
