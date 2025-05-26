Clean Logs Server dengan Laporan Otomatis via Lunarsender

Skrip bash ini berfungsi untuk membersihkan berbagai log di server (aaPanel, systemd journal, webserver, MySQL, PHP, mail, dll) secara otomatis, serta mengirimkan laporan hasil pembersihan melalui WhatsApp menggunakan Lunarsender API.

Fitur:

Membersihkan log systemd journal lebih dari 14 hari

Menghapus log lama (lebih dari 14 hari) di folder:

/www/wwwlogs/ (log webserver seperti Nginx/Apache)

/www/server/php/var/log/ (log PHP)

/var/log/mysql/ dan truncate error.log MySQL

/www/server/panel/logs/ dan truncate error.log aaPanel

Log mail dan log sistem umum di /var/log/

Membersihkan cache apt (apt-get clean)

Mengirimkan laporan pembersihan log secara otomatis ke nomor WhatsApp via Lunarsender API

Menampilkan status dan response API secara real-time di terminal dan menyimpan ke log file /var/log/clean-logs.log


Cara penggunaan:

Simpan skrip sebagai file, misal /usr/local/bin/clean-logs.sh

Edit bagian API, sender ( nomor untuk pengirim format 628xx ), dan number ( nomor untuk penerima )
Link pembelian Lunarsender:
https://digilunar.com/promo-lunarsender

Beri hak eksekusi:
sudo chmod +x /usr/local/bin/clean-logs.sh

Jalankan manual:
sudo /usr/local/bin/clean-logs.sh

(Opsional) Buat cron job supaya berjalan otomatis setiap 2 minggu:
Edit crontab dengan sudo crontab -e lalu tambahkan baris:
0 2 */14 * * /usr/local/bin/clean-logs.sh >> /var/log/clean-logs-cron.log 2>&1

Requirements:

Server terhubung internet

curl sudah terinstall dan mendukung TLS 1.2+

Server Linux dengan systemd dan aaPanel (untuk path log default)

Konfigurasi:

API Key dan nomor WhatsApp sudah diatur di skrip

Untuk mengganti nomor tujuan atau pengirim, edit variabel API_URL di skrip

Contoh output di terminal:

===== Log Clean Started: 26-05-2025 05:34:26 =====
🧹 Laporan Pembersihan Log Server
✅ Log systemd dibersihkan (>14 hari)
✅ Log Nginx/Apache dibersihkan (>14 hari)
✅ Log PHP dibersihkan
✅ error.log MySQL dikosongkan
✅ Log MySQL dibersihkan
✅ Log aaPanel dibersihkan
✅ error.log aaPanel dikosongkan
✅ Log mail dibersihkan
✅ Log sistem umum dibersihkan
✅ Cache apt dibersihkan

Dikirim dengan Lunarsender

Mengirim laporan ke Lunarsender API...
Response dari API Lunarsender:
{"status":true,"msg":"Message sent successfully!"}
===== Log Clean Finished: 26-05-2025 05:34:26 =====
