echo "--- فحص الاتصال ونوع المعالج ---"
adb_check=$(adb devices | grep -v "List" | grep "device")
fast_check=$(fastboot devices)

if [ ! -z "$adb_check" ]; then
    echo "[+] تم اكتشاف هاتف في وضع ADB"
    echo "الأمر المقترح: adb shell content insert --uri content://settings/secure --bind name:s:user_setup_complete --bind value:s:1"
elif [ ! -z "$fast_check" ]; then
    echo "[+] تم اكتشاف هاتف في وضع Fastboot"
    echo "الأمر المقترح: fastboot erase frp"
else
    echo "[!] لم يتم اكتشاف هاتف. تأكد من وصلة OTG وتفعيل تصحيح USB أو وضع الفاست بوت."
fi
