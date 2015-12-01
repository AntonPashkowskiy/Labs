using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

using Utilities;

namespace WebcamGUI_v2
{
    static class Program
    {
        private static MainForm mainForm;
        private static globalKeyboardHook globalHook;

        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Initialize();
            Application.Run(mainForm);
        }

        private static void Initialize()
        {
            mainForm = new MainForm();
            globalHook = new globalKeyboardHook();
            globalHook.HookedKeys.Add(Keys.Home);
            globalHook.KeyDown += OnGlobalKeyDown;
        }

        private static void OnGlobalKeyDown(object sender, KeyEventArgs e)
        {
            mainForm.ToggleWindow();
        }
    }
}
