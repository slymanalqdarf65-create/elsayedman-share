apt update && apt upgrade -y
apt install android-tools-adb android-tools-fastboot python3 python3-pip git wget -y
apt install android-tools-adb android-tools-fastboot python3-pip git -y
git clone https://github.com/bkerler/mtkclient
cat << 'EOF' > frp_helper.sh
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
EOF

chmod +x frp_helper.sh
exit
exit
open
data
exit
exit
lsusb
apt update
apt install adb -y
adb devices
exit
vncserver
exit
vncserver
apt update && apt install tigervnc-standalone-server xfce4 xfce4-goodies -y
aaaapt update && apt install tigervnc-standalone-server xfce4 xfce4-goodies -y
exit
vncserver :1 -geometry 1280x720
apt update && apt install tigervnc-standalone-server xfce4 xfce4-goodies -y
export DISPLAY=:0
startxfce4
apt update
apt install xfce4 dbus-x11 -y
export DISPLAY=:0
export PULSE_SERVER=127.0.0.1
startxfce4
dbus-launch --exit-with-session startxfce4
pkg install proot-distro
proot-distro login debian --shared-tmp
apt update
apt install xfce4 xfce4-goodies dbus-x11 -y
export DISPLAY=:0 && export PULSE_SERVER=127.0.0.1 && dbus-launch --exit-with-session startxfce4
termux-x11 :0 &
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
sxit
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
apt update
apt install firefox-esr -y
termux-x11 :0 &
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
apt update
apt install firefox-esr -y
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
apt update && apt install dbus dbus-x11 -y
proot-distro login debian --shared-tmp
firefox-esr &
proot-distro login debian --shared-tmp
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
DISPLAY=:1 dbus-launch --exit-with-session xfce4-session &
exit
