using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SQLite;

namespace GatelessGateSharp
{

    public partial class MainForm : Form
    {
        String databaseFileName = "GatelessGateSharp.sqlite";
        String logFileName = "GatelessGateSharp.log";
        const int richTextBoxLogMaxLines = 65536;

        public void Logger(String lines)
        {
            System.IO.StreamWriter file = new System.IO.StreamWriter(logFileName, true);
            file.WriteLine(lines);
            file.Close();
            richTextBoxLog.Text += lines + "\n";
            if (richTextBoxLog.Lines.Length > richTextBoxLogMaxLines)
            {
                richTextBoxLog.Select(0, richTextBoxLog.Text.IndexOf('\n') + 1);
                richTextBoxLog.SelectedRtf = "{\\rtf1\\ansi\\ansicpg1252\\deff0\\deflang1053\\uc1 }";
            }
        }

        public MainForm()
        {
            InitializeComponent();
            Logger("Gateless Gate # started.");
        }

        private void CreateNewDatabase()
        {
            SQLiteConnection.CreateFile(databaseFileName);
            SQLiteConnection conn = new SQLiteConnection("Data Source=" + databaseFileName + ";Version=3;");
            conn.Open();
            String sql = "create table wallet_addresses (coin varchar(128), address varchar(128));";
            SQLiteCommand command = new SQLiteCommand(sql, conn);
            command.ExecuteNonQuery();
            conn.Close();
        }

        private void LoadDatabase()
        {
            SQLiteConnection conn = new SQLiteConnection("Data Source=" + databaseFileName + ";Version=3;");
            conn.Open();
            String sql = "select * from wallet_addresses";
            SQLiteCommand command = new SQLiteCommand(sql, conn);
            SQLiteDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                if ((String)reader["coin"] == "bitcoin")
                {
                    textBoxBitcoinAddress.Text = (String)reader["address"];
                }
                else if ((String)reader["coin"] == "ethereum")
                {
                    textBoxEthereumAddress.Text = (String)reader["address"];
                }
                else if ((String)reader["coin"] == "monero")
                {
                    textBoxMoneroAddress.Text = (String)reader["address"];
                }
                else if ((String)reader["coin"] == "zcash")
                {
                    textBoxZcashAddress.Text = (String)reader["address"];
                }
            }
            conn.Close();
        }

        private void UpdateDatabase()
        {
            SQLiteConnection conn = new SQLiteConnection("Data Source=" + databaseFileName + ";Version=3;");
            conn.Open();
            String sql = "delete from wallet_addresses";
            SQLiteCommand command = new SQLiteCommand(sql, conn);
            command.ExecuteNonQuery();

            sql = "insert into wallet_addresses (coin, address) values (@coin, @address)";
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "bitcoin");
            command.Parameters.AddWithValue("@address", textBoxBitcoinAddress.Text);
            command.ExecuteNonQuery();
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "ethereum");
            command.Parameters.AddWithValue("@address", textBoxEthereumAddress.Text);
            command.ExecuteNonQuery();
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "monero");
            command.Parameters.AddWithValue("@address", textBoxMoneroAddress.Text);
            command.ExecuteNonQuery();
            command = new SQLiteCommand(sql, conn);
            command.Parameters.AddWithValue("@coin", "zcash");
            command.Parameters.AddWithValue("@address", textBoxZcashAddress.Text);
            command.ExecuteNonQuery();
            
            conn.Close();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            if (!System.IO.File.Exists(databaseFileName))
                CreateNewDatabase();
            LoadDatabase();
        }

        private void textBoxBitcoinAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void textBoxEthereumAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void textBoxMoneroAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void textBoxZcashAddress_TextChanged(object sender, EventArgs e)
        {
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            UpdateDatabase();
        }
    }
}
