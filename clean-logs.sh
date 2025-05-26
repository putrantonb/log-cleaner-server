#!/bin/bash

LOGFILE="/var/log/clean-logs.log"
TEMP_LOG="/tmp/clean-logs-report.txt"

# Waktu mulai
START_TIME=$(date +"%d-%m-%Y %H:%M:%S")

echo "===== Log Clean Started: $START_TIME =====" | tee -a $LOGFILE
echo "🧹 *Laporan Pembersihan Log Server*" > $TEMP_LOG
echo "_Waktu: $START_TIME_" >> $TEMP_LOG
echo "" >> $TEMP_LOG

# Fungsi helper untuk log & echo
log_and_echo() {
  echo "$1" | tee -a $LOGFILE >> $TEMP_LOG
}

# 1. Bersihkan journal systemd
journalctl --vacuum-time=14d >> $LOGFILE 2>&1
log_and_echo "✅ Log systemd dibersihkan (>14 hari)"

# 2. Log webserver
if [ -d /www/wwwlogs/ ]; then
  find /www/wwwlogs/ -type f -name "*.log" -mtime +14 -exec rm -f {} \; >> $LOGFILE 2>&1
  log_and_echo "✅ Log Nginx/Apache dibersihkan (>14 hari)"
else
  log_and_echo "ℹ️ Folder log Nginx/Apache tidak ditemukan"
fi

# 3. Log PHP
if [ -d /www/server/php/ ]; then
  find /www/server/php/ -type f -path "*/var/log/*.log" -exec rm -f {} \; >> $LOGFILE 2>&1
  log_and_echo "✅ Log PHP dibersihkan"
else
  log_and_echo "ℹ️ Folder log PHP tidak ditemukan"
fi

# 4. Log MySQL
if [ -f /var/log/mysql/error.log ]; then
  truncate -s 0 /var/log/mysql/error.log
  log_and_echo "✅ error.log MySQL dikosongkan"
fi

if [ -d /var/log/mysql/ ]; then
  find /var/log/mysql/ -type f -name "*.log" -mtime +14 -exec rm -f {} \; >> $LOGFILE 2>&1
  log_and_echo "✅ Log MySQL dibersihkan"
else
  log_and_echo "ℹ️ Log MySQL tidak ditemukan (folder /var/log/mysql/ tidak ada)"
fi

# 5. Log aaPanel
if [ -d /www/server/panel/logs/ ]; then
  find /www/server/panel/logs/ -type f -name "*.log" -mtime +14 -exec rm -f {} \; >> $LOGFILE 2>&1
  log_and_echo "✅ Log aaPanel dibersihkan"
else
  log_and_echo "ℹ️ Log aaPanel tidak ditemukan"
fi

if [ -f /www/server/panel/data/error.log ]; then
  truncate -s 0 /www/server/panel/data/error.log
  log_and_echo "✅ error.log aaPanel dikosongkan"
fi

# 6. Log mail
find /var/log/ -type f -name "mail*" -mtime +14 -exec rm -f {} \; >> $LOGFILE 2>&1
log_and_echo "✅ Log mail dibersihkan"

# 7. Log sistem umum
find /var/log/ -type f -name "*.log" -mtime +14 -exec rm -f {} \; >> $LOGFILE 2>&1
log_and_echo "✅ Log sistem umum dibersihkan"

# 8. Cache apt
apt-get clean >> $LOGFILE 2>&1
log_and_echo "✅ Cache apt dibersihkan"

echo "" >> $TEMP_LOG
log_and_echo "> Dikirim dengan Lunarsender"

# Kirim pesan ke WhatsApp via Lunarsender API
MESSAGE=$(cat $TEMP_LOG | sed ':a;N;$!ba;s/\n/%0A/g')
API_URL="https://sender.digilunar.com/send-message?api_key=WSdUEKG7mss6OpXEhPtOQlpZpj9QLr61F9qv7L2t&sender=6285156180980&number=6285764615794&message=${MESSAGE}"

echo "Mengirim laporan ke Lunarsender API..."
API_RESPONSE=$(curl -s -G \
  --data-urlencode "api_key=WSdUEKG7mss6OpXEhPtOQlpZpj9QLr61F9qv7L2t" \
  --data-urlencode "sender=6285156180980" \
  --data-urlencode "number=6285764615794" \
  --data-urlencode "message=$(cat $TEMP_LOG)" \
  "https://sender.digilunar.com/send-message")

echo "Response dari API Lunarsender:" | tee -a $LOGFILE
echo "$API_RESPONSE" | tee -a $LOGFILE

rm -f $TEMP_LOG

echo "===== Log Clean Finished: $(date +"%d-%m-%Y %H:%M:%S") =====" | tee -a $LOGFILE
