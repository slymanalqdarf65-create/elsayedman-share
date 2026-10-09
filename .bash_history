            <h2 class="text-xl font-bold text-slate-200 mb-4 pb-2 border-b border-slate-700">الملفات المتاحة للتحميل</h2>
            <div class="space-y-3">
                {% if files %}
                    {% for file in files %}
                    <div class="flex items-center justify-between bg-slate-700/50 hover:bg-slate-700 p-4 rounded-xl border border-slate-600/50 transition-all">
                        <div class="truncate pl-4">
                            <p class="font-medium text-slate-100 truncate">{{ file.name }}</p>
                            <p class="text-xs text-slate-400 mt-1">{{ file.size }} • {{ file.date }}</p>
                        </div>
                        <a href="/download/{{ file.name }}" class="bg-emerald-600 hover:bg-emerald-500 text-white text-sm font-medium px-4 py-2 rounded-lg transition-colors flex-shrink-0">
                            تنزيل
                        </a>
                    </div>
                    {% endfor %}
                {% else %}
                    <p class="text-slate-500 text-center py-6 text-sm">لا توجد ملفات مرفوعة حتى الآن.</p>
                {% endif %}
            </div>
        </div>
    </div>

    <script>
        const fileInput = document.getElementById('fileInput');
        const fileNameDisplay = document.getElementById('fileNameDisplay');
        const uploadForm = document.getElementById('uploadForm');
        const progressContainer = document.getElementById('progressContainer');
        const progressBar = document.getElementById('progressBar');
        const progressText = document.getElementById('progressText');
        const submitBtn = document.getElementById('submitBtn');

        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                fileNameDisplay.textContent = e.target.files[0].name;
            }
        });

        uploadForm.addEventListener('submit', (e) => {
            e.preventDefault();
            if (!fileInput.files.length) return;

            const formData = new FormData();
            formData.append('file', fileInput.files[0]);

            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/upload', true);

            progressContainer.classList.remove('hidden');
            submitBtn.disabled = true;
            submitBtn.classList.add('opacity-50');

            xhr.upload.onprogress = (e) => {
                if (e.lengthComputable) {
                    const percent = Math.round((e.loaded / e.total) * 100);
                    progressBar.style.width = percent + '%';
                    progressText.textContent = percent + '%';
                }
            };

            xhr.onload = () => {
                if (xhr.status === 200) {
                    window.location.reload();
                } else {
                    alert('حدث خطأ أثناء الرفع!');
                    submitBtn.disabled = false;
                    submitBtn.classList.remove('opacity-50');
                }
            };

            xhr.send(formData);
        });
    </script>
</body>
</html>
'''

@app.route('/')
def index():
    files = get_file_info()
    return render_template_string(HTML_TEMPLATE, files=files)

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files.get('file')
    if file:
        file.save(os.path.join(UPLOAD_FOLDER, file.filename))
        return "OK", 200
    return "No file", 400

@app.route('/download/<filename>')
def download(filename):
    return send_from_directory(UPLOAD_FOLDER, filename, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

python3 app.py
cp uploads/*.jpg ./my_photo.jpg 2>/dev/null || cp uploads/*.jpeg ./my_photo.jpg 2>/dev/null || cp uploads/*.png ./my_photo.jpg 2>/dev/null
python3 app.py
cat << 'EOF' > app.py
import os
import time
from flask import Flask, request, render_template_string, send_from_directory

app = Flask(__name__)
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def get_file_info():
    files_list = []
    for filename in os.listdir(UPLOAD_FOLDER):
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        if os.path.isfile(filepath):
            size_bytes = os.path.getsize(filepath)
            if size_bytes < 1024:
                size_str = f"{size_bytes} B"
            elif size_bytes < 1024 * 1024:
                size_str = f"{size_bytes / 1024:.1f} KB"
            else:
                size_str = f"{size_bytes / (1024 * 1024):.1f} MB"
            
            mtime = time.strftime('%Y-%m-%d %H:%M', time.localtime(os.path.getmtime(filepath)))
            files_list.append({
                'name': filename,
                'size': size_str,
                'date': mtime
            })
    return files_list

HTML_TEMPLATE = '''
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>منصة السيد مان لمشاركة الملفات</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-900 text-slate-100 min-h-screen font-sans flex flex-col items-center justify-start p-4 md:p-8">

    <div class="w-full max-w-2xl bg-slate-800 border border-slate-700 rounded-2xl shadow-2xl p-6 md:p-8 mt-4">
        
        <!-- Header with Profile Picture & Name -->
        <div class="flex flex-col items-center mb-8 border-b border-slate-700 pb-6">
            <div class="relative w-28 h-28 mb-4">
                <img src="/my_photo.jpg" 
                     onerror="this.src='https://ui-avatars.com/api/?name=Elsayed+Man&background=0D8ABC&color=fff&size=128'" 
                     alt="صورة السيد مان" 
                     class="w-28 h-28 rounded-full object-cover border-4 border-blue-500 shadow-2xl">
            </div>
            <h1 class="text-3xl font-extrabold text-white mb-1">منصة السيد مان</h1>
            <p class="text-blue-400 font-medium text-sm">مرحباً بك في السيرفر الخاص للسيد مان</p>
        </div>

        <!-- Upload Form -->
        <form id="uploadForm" class="space-y-4">
            <div class="border-2 border-dashed border-slate-600 hover:border-blue-500 transition-colors rounded-xl p-6 text-center cursor-pointer relative bg-slate-800/50">
                <input type="file" id="fileInput" name="file" required class="absolute inset-0 w-full h-full opacity-0 cursor-pointer">
                <div class="space-y-2">
                    <svg class="w-10 h-10 mx-auto text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path></svg>
                    <p class="text-slate-300 font-medium" id="fileNameDisplay">اضغط هنا واختر الملف لرفعه</p>
                </div>
            </div>

            <!-- Progress Bar -->
            <div id="progressContainer" class="hidden space-y-1">
                <div class="w-full bg-slate-700 rounded-full h-3 overflow-hidden">
                    <div id="progressBar" class="bg-blue-500 h-full w-0 transition-all duration-200"></div>
                </div>
                <p id="progressText" class="text-xs text-slate-400 text-left">0%</p>
            </div>

            <button type="submit" id="submitBtn" class="w-full bg-blue-600 hover:bg-blue-500 text-white font-semibold py-3 px-6 rounded-xl transition-all shadow-lg shadow-blue-600/30">
                رفع الملف الآن
            </button>
        </form>

        <!-- Files List -->
        <div class="mt-8">
            <h2 class="text-lg font-bold text-slate-200 mb-4 pb-2 border-b border-slate-700">الملفات المتاحة للتحميل</h2>
            <div class="space-y-3">
                {% if files %}
                    {% for file in files %}
                    <div class="flex items-center justify-between bg-slate-700/50 hover:bg-slate-700 p-4 rounded-xl border border-slate-600/50 transition-all">
                        <div class="truncate pl-4">
                            <p class="font-medium text-slate-100 truncate">{{ file.name }}</p>
                            <p class="text-xs text-slate-400 mt-1">{{ file.size }} • {{ file.date }}</p>
                        </div>
                        <a href="/download/{{ file.name }}" class="bg-emerald-600 hover:bg-emerald-500 text-white text-sm font-medium px-4 py-2 rounded-lg transition-colors flex-shrink-0">
                            تنزيل
                        </a>
                    </div>
                    {% endfor %}
                {% else %}
                    <p class="text-slate-500 text-center py-6 text-sm">لا توجد ملفات مرفوعة حتى الآن.</p>
                {% endif %}
            </div>
        </div>
    </div>

    <script>
        const fileInput = document.getElementById('fileInput');
        const fileNameDisplay = document.getElementById('fileNameDisplay');
        const uploadForm = document.getElementById('uploadForm');
        const progressContainer = document.getElementById('progressContainer');
        const progressBar = document.getElementById('progressBar');
        const progressText = document.getElementById('progressText');
        const submitBtn = document.getElementById('submitBtn');

        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                fileNameDisplay.textContent = e.target.files[0].name;
            }
        });

        uploadForm.addEventListener('submit', (e) => {
            e.preventDefault();
            if (!fileInput.files.length) return;

            const formData = new FormData();
            formData.append('file', fileInput.files[0]);

            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/upload', true);

            progressContainer.classList.remove('hidden');
            submitBtn.disabled = true;
            submitBtn.classList.add('opacity-50');

            xhr.upload.onprogress = (e) => {
                if (e.lengthComputable) {
                    const percent = Math.round((e.loaded / e.total) * 100);
                    progressBar.style.width = percent + '%';
                    progressText.textContent = percent + '%';
                }
            };

            xhr.onload = () => {
                if (xhr.status === 200) {
                    window.location.reload();
                } else {
                    alert('حدث خطأ أثناء الرفع!');
                    submitBtn.disabled = false;
                    submitBtn.classList.remove('opacity-50');
                }
            };

            xhr.send(formData);
        });
    </script>
</body>
</html>
'''

@app.route('/')
def index():
    files = get_file_info()
    return render_template_string(HTML_TEMPLATE, files=files)

@app.route('/my_photo.jpg')
def profile_photo():
    if os.path.exists('my_photo.jpg'):
        return send_from_directory('.', 'my_photo.jpg')
    elif os.path.exists(os.path.join(UPLOAD_FOLDER, 'my_photo.jpg')):
        return send_from_directory(UPLOAD_FOLDER, 'my_photo.jpg')
    # إذا لم توجد الصورة يرجع صورة افتراضية بالاسم
    for filename in os.listdir(UPLOAD_FOLDER):
        if filename.lower().endswith(('.jpg', '.jpeg', '.png')):
            return send_from_directory(UPLOAD_FOLDER, filename)
    return "", 404

@app.route('/upload', methods=['POST'])
def upload():
    file = request.files.get('file')
    if file:
        file.save(os.path.join(UPLOAD_FOLDER, file.filename))
        return "OK", 200
    return "No file", 400

@app.route('/download/<filename>')
def download(filename):
    return send_from_directory(UPLOAD_FOLDER, filename, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

python3 app.py
apt update && apt install nodejs npm -y && npm install -g localtunnel
python3 app.py &
lt --port 5000 --subdomain elsayedman
echo -e "Flask==3.0.0\ngunicorn==21.2.0" > requirements.txt
echo "web: gunicorn app:app" > Procfile
ls -la
git branch -M main
git remote add origin https://github.com/slymanalqdarf65-create/elsayedman-share.git
git push -u origin main
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/slymanalqdarf65-create/elsayedman-share.git
git push -u origin main
git reset
echo -e ".npm/\n.cache/\nmtkclient/\nnode_modules/" > .gitignore
git add app.py Procfile requirements.txt my_photo.jpg templates/ uploads/ .gitignore
git commit -m "Add project files"
git push -u origin main
git add app.py Procfile requirements.txt my_photo.jpg .gitignore
git commit -m "Add core project files"
git push -u origin main
cp app.py Procfile requirements.txt my_photo.jpg /sdcard/ Download/ 2>/dev/null || cp app.py Procfile requirements.txt my_photo.jpg /sdcard/
cat app.py
cd elsayedman-share
nano app.py
nano app.py
git add app.py
git commit -m "Fix redirect after upload"
git push
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
DISPLAY=:1 dbus-launch --exit-with-session xfce4-session &
proot-distro login debian --shared-tmpexit
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
exit
termux-x11 :0 &
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
DISPLAY=:1 dbus-launch --exit-with-session xfce4-session &
termux-x11 :0 &
proot-distro login debian
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
export DISPLAY=:0
startxfce4
cat ~/.xsession-errors
export DISPLAY=:0
ls /tmp/.X11-unix/
startxfce4
exit
export DISPLAY=:0
ls /tmp/.X11-unix/
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
exit
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
exit
termux-setup-storage
cp /sdcard/Download/google*.html .
ls /sdcard/Download/*.html
echo "google-site-verification: googleffe54ccee71.html" > googleffe54ccee71.html
mv googleffe54ccee71.html ffe54ccee71.html
echo "google-site-verification: ffe54ccee71.html" > ffe54ccee71.html
git add .
git commit -m "add google html file"
git push
git push --set-upstream origin main
git push --set-upstream origin main
git push --force origin main
nano index.html
find . -name "index.html"
cat index.html
find . -type f -name "*.html"
ls -la
find Public Templates -name "*.html"
nano Public/index.html
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
exit
lt --port 8080
apt update && apt upgrade -y
apt install nmap -y
nmap scanme.nmap.org
echo "nameserver 8.8.8.8" > /etc/resolv.conf
nmap scanme.nmap.org
ping -c 3 google.com
apt install sqlmap -y
apt install git -y
apt install python3-pip -y
git clone https://github.com
git clone https://github.com
git clone https://github.com
git clone https://github.com
git clone https://github.com
apt install wget -y
wget bit.ly/zphsh
wget https://github.com
apt install unzip -y && unzip master.zip
cd zphisher-master && bash zphisher.sh
apt install setoolkit -y
pip install pyphisher --break-system-packages
pyphisher
apt install php -y
pyphisher
apt install wget -y && wget https://github.com -O cloudflared
wget https://bit.ly -O cloudflared
chmod +x cloudflared
./cloudflared tunnel --url http://127.0.0.1:8080
pyphisher
apt install cloudflared -y
apt install nodejs npm -y
npm install -g localtunnel
pyphisher
sqlmap 
-hhttp://vulnweb.com
pyphisher
sqlmap 
sqlmap --update
sqlmap -u "http://vulnweb.com" --dbs
apt update
apt install libmagic1 -y
apt install python3-pip -y
sqlmap -u "http://vulnweb.com" --dbs
http://vulnweb.com
apt update && apt install libmagic1 -y
http://vulnweb.com
sqlmap -u "http://vulnweb.com" --dbs
apt update && apt install libmagic1 -y
python3 /usr/bin/sqlmap -u "http://vulnweb.com" --dbs
python3 /usr/bin/sqlmap -u "http://vulnweb.com" --dbs
python3 /usr/bin/sqlmap -u "http://vulnweb.com" --dbs
exit
python3 /usr/bin/sqlmap -u "http://vulnweb.com" --dbs
python3 /usr/bin/sqlmap -u "http://vulnweb.com" --dbs
python3 /usr/bin/sqlmap -u "http://vulnweb.com" --dbs
curl -I -L --max-time 10 <TARGET_URL>
curl -I -L --max-time 10 "http://example.com"
sqlmap -u "http://example.com/page.php?id=1" --random-agent
apt update && apt upgrade -y
pip install --upgrade python-magic
apt update
apt install python3-magic -y
apt install libmagic1 -y
ln -s /usr/lib/*-linux-gnu*/libmagic.so* /usr/lib/libmagic.so.1
ldconfig
pip install python-magic --break-system-packages
python3 /usr/bin/sqlmap -u "http://vulnweb.com" --dbs
sqlmap -u "http://example.com/page.php?id=1" --random-agent
ln -s /usr/lib/x86_64-linux-gnu/libmagic.so.1 /usr/lib/libmagic.so.1
ln -s /usr/lib/aarch64-linux-gnu/libmagic.so.1 /usr/lib/libmagic.so.1
python3 /usr/share/sqlmap/sqlmap.py -u "http://vulnweb.com" --dbs
python3 /usr/share/sqlmap/sqlmap.py -u "http://vulnweb.com" --dbs --disable-coloring
python3 /usr/share/sqlmap/sqlmap.py -u "http://vulnweb.com" --dbs --disable-coloring
python3 /usr/share/sqlmap/sqlmap.py -u "http://vulnweb.com" --dbs --disable-coloring
DISPLAY=:0 dbus-launch --exit-with-session xfce4-session &
python3 /usr/share/sqlmap/sqlmap.py -u "http://vulnweb.com" --dbs --disable-coloring
python3 /usr/share/sqlmap/sqlmap.py -u "http://vulnweb.com" --dbs --disable-coloring
nmap scanme.nmap.org
nikto -h http://cirt.net
nmap -Pn scanme.nmap.org
apt install nikto -y
nikto -h http://cirt.net
nmap -Pn scanme.nmap.org
nmap -Pn --unprivileged scanme.nmap.org
apt update
apt install nikto -y
nikto -h http://cirt.net
apt install git perl -y
git clone https://github.com
cd nikto/program
perl nikto.pl -h http://cirt.net
git clone https://github.com
cd nikto/program
perl nikto.pl -h http://cirt.net
git clone https://github.com && cd nikto/
# 1. تحديث الحزم
apt update
# 2. تثبيت المتطلبات (لو مش موجودة)
apt install git perl -y
# 3. استنساخ المستودع الصحيح
git clone https://github.com/sullo/nikto.git
# 4. الدخول لمجلد البرنامج
cd nikto/program
# 5. تشغيل Nikto (مثال)
perl nikto.pl -h http://cirt.net
apt install libxml-writer-perl -y
perl nikto.pl -h http://cirt.net
apt install golang curl -y
curl -sSL https://githubusercontent.com | bash
./phoneinfoga scan -n +249900000000
cd ~ && curl -sSL https://githubusercontent.com | bash
# اخرج من مجلد nikto الأول
cd \~
# حمل النسخة المناسبة لـ ARM64 (لأن جهازك aarch64)
curl -sSL https://github.com/sundowndev/phoneinfoga/releases/latest/download/phoneinfoga_Linux_arm64.tar.gz -o phoneinfoga.tar.gz
# فك الضغط
tar -xzf phoneinfoga.tar.gz
# أعطِ الملف صلاحية التنفيذ
chmod +x phoneinfoga
# جرب تشغيله
./phoneinfoga version
./phoneinfoga scan -n +249909131580
./phoneinfoga scan -n +249961367021
python3 pyphisher.py
python3 pyphisher.py
exit
pyphisher
pyphisher
pyphsiher
pyphisher
