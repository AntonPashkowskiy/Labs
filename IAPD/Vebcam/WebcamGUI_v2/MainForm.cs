using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WebcamGUI_v2
{
    public partial class MainForm : Form
    {
        private bool isHided;

        public MainForm()
        {
            InitializeComponent();
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
    }
}
