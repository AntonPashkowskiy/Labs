using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;

using AForge.Video;
using AForge.Video.VFW;
using AForge.Video.DirectShow;
using System.Diagnostics;

namespace WebcamLib
{
    public class WebCamera : IDisposable
    {
        private FilterInfoCollection videoDevices = new FilterInfoCollection(FilterCategory.VideoInputDevice);
        private VideoCaptureDevice videoSourse;
        private AVIWriter videoWriter;
        private Queue<ShootingSettings> shootingPhotoRequestQueue;

        public event NewFrameEventHandler NewFrame;

        public bool CameraIsOn 
        { 
            get 
            {
                return videoSourse.IsRunning; 
            } 
        }

        public static bool CameraIsExist
        {
            get
            {
                var videoDevices = new FilterInfoCollection(FilterCategory.VideoInputDevice);
                return videoDevices.Count != 0;
            }
        }

        public WebCamera()
        {
            try
            {
                if (videoDevices.Count == 0)
                {
                    throw new WebCameraException("Web camera not found.");
                }
                videoSourse = new VideoCaptureDevice(videoDevices[0].MonikerString);
                videoSourse.NewFrame += NewFrameHandler;
                videoWriter = new AVIWriter("xvid");
            }
            catch (Exception e)
            {
                throw new WebCameraException("Creating web camera instance failed. ", e);
            }
            shootingPhotoRequestQueue = new Queue<ShootingSettings>();
        }

        public WebCameraInformation GetInformation()
        {
            return new WebCameraInformation()
            {
               Name = videoDevices[0].Name,
               MonikerString = videoDevices[0].MonikerString
            };
        }

        public void StartShootVideo(ShootingSettings settings)
        {
            var frameSize = videoSourse.VideoCapabilities[0].FrameSize;
            videoWriter.FrameRate = settings.FrameRate;
            videoWriter.Open(settings.SavingPath, frameSize.Width, frameSize.Height);
            videoSourse.Start();
        }

        public void StopShootVideo()
        {
            videoSourse.Stop();
            videoWriter.Close();
        }

        public void ShootPhoto(ShootingSettings settings)
        {
            shootingPhotoRequestQueue.Enqueue(settings); 
        }

        private void NewFrameHandler(object sender, NewFrameEventArgs eventArgs)
        {
            if (NewFrame != null)
            {
                ResolveAllPhotoShootingRequests(eventArgs.Frame);
                ResolveVideoShootingRequest(eventArgs.Frame);
                NewFrame(sender, eventArgs);
            }
        }

        public void Dispose()
        {
            if (CameraIsOn)
            {
                videoSourse.Stop();
                videoWriter.Close();
            }
        }

        private void ResolveAllPhotoShootingRequests(Bitmap frame)
        {
            Bitmap inputFrame = (Bitmap)frame.Clone();
            ShootingSettings shootingRequest;

            while (shootingPhotoRequestQueue.Count != 0)
            {
                shootingRequest = shootingPhotoRequestQueue.Dequeue();
                inputFrame.Save(shootingRequest.SavingPath, ImageFormat.Png);
            }
        }

        private void ResolveVideoShootingRequest(Bitmap frame)
        {
            Bitmap inputFrame = (Bitmap)frame.Clone();

            if (CameraIsOn)
            {
                videoWriter.AddFrame(inputFrame);
            }
        }
    }
}
