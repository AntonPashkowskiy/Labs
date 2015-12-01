namespace WebcamGUI_v2
{
    partial class MainForm
    {
        /// <summary>
        /// Требуется переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Обязательный метод для поддержки конструктора - не изменяйте
        /// содержимое данного метода при помощи редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.framePictureBox = new System.Windows.Forms.PictureBox();
            this.cameraNameLabel = new System.Windows.Forms.Label();
            this.playPauseButton = new System.Windows.Forms.Button();
            this.snapshootButton = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.framePictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // framePictureBox
            // 
            this.framePictureBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.framePictureBox.BackColor = System.Drawing.SystemColors.AppWorkspace;
            this.framePictureBox.Location = new System.Drawing.Point(13, 13);
            this.framePictureBox.Name = "framePictureBox";
            this.framePictureBox.Size = new System.Drawing.Size(758, 417);
            this.framePictureBox.TabIndex = 0;
            this.framePictureBox.TabStop = false;
            // 
            // cameraNameLabel
            // 
            this.cameraNameLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.cameraNameLabel.AutoSize = true;
            this.cameraNameLabel.Location = new System.Drawing.Point(14, 485);
            this.cameraNameLabel.Name = "cameraNameLabel";
            this.cameraNameLabel.Size = new System.Drawing.Size(0, 13);
            this.cameraNameLabel.TabIndex = 1;
            // 
            // playPauseButton
            // 
            this.playPauseButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.playPauseButton.Location = new System.Drawing.Point(608, 465);
            this.playPauseButton.Name = "playPauseButton";
            this.playPauseButton.Size = new System.Drawing.Size(163, 33);
            this.playPauseButton.TabIndex = 2;
            this.playPauseButton.Text = "Play / Pause";
            this.playPauseButton.UseVisualStyleBackColor = true;
            // 
            // snapshootButton
            // 
            this.snapshootButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.snapshootButton.Location = new System.Drawing.Point(439, 465);
            this.snapshootButton.Name = "snapshootButton";
            this.snapshootButton.Size = new System.Drawing.Size(163, 33);
            this.snapshootButton.TabIndex = 3;
            this.snapshootButton.Text = "Snapshoot";
            this.snapshootButton.UseVisualStyleBackColor = true;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(784, 511);
            this.Controls.Add(this.snapshootButton);
            this.Controls.Add(this.playPauseButton);
            this.Controls.Add(this.cameraNameLabel);
            this.Controls.Add(this.framePictureBox);
            this.MinimumSize = new System.Drawing.Size(800, 550);
            this.Name = "MainForm";
            this.Padding = new System.Windows.Forms.Padding(10);
            this.ShowIcon = false;
            this.Text = "Webcam";
            ((System.ComponentModel.ISupportInitialize)(this.framePictureBox)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox framePictureBox;
        private System.Windows.Forms.Label cameraNameLabel;
        private System.Windows.Forms.Button playPauseButton;
        private System.Windows.Forms.Button snapshootButton;
    }
}

