using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace WebcamGUI
{
    /// <summary>
    /// Логика взаимодействия для App.xaml
    /// </summary>
    public partial class App : System.Windows.Application
    {
        MainWindow mainWindow = new MainWindow();
        HotKey hotKey;
        
        private void ApplicationStartup(object sender, StartupEventArgs e)
        {
            hotKey = new HotKey(ModifierKeys.Control, System.Windows.Forms.Keys.H, mainWindow);
            hotKey.HotKeyPressed += HotKeyHandler;
            mainWindow.Show();
        }

        void HotKeyHandler(HotKey obj)
        {
            mainWindow.ToggleWindow();
        }
    }
}
