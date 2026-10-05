from flask import Flask, render_template, request, redirect, url_for, send_from_directory
import os

app = Flask(__name__)
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def index():
    files = os.listdir(app.config['UPLOAD_FOLDER'])
    return render_template('index.html', files=files)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' in request.files:
        file = request.files['file']
        if file.filename != '':
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename))
    return redirect('/')

@app.route('/uploads/<filename>')
def download_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
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
