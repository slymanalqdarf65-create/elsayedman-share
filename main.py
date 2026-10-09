from flask import Flask, render_template

app = Flask(__name__)

# قائمة بسيطة بالمسلسلات والألعاب وروابط تحميلها من ميديا فاير
data_list = [
    {"title": "لعبة ببجي موبايل", "link": "https://mediafire.com"},
    {"title": "مسلسل أرطغرل - الحلقة 1", "link": "https://mediafire.com"},
    {"title": "برنامج تيرمكس التحديث الأخير", "link": "https://mediafire.com"}
]

@app.route('/')
def home():
    # إرسال هذه القائمة لصفحة الـ HTML لتعرضها تلقائياً للزوار
    return render_template('index.html', items=data_list)

if __name__ == '__main__':
    app.run(debug=True)

