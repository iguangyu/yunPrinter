# from calendar import calendar
import calendar
import time
from main import app
from flask import request, send_file
from flask_cors import CORS, cross_origin
import os
from ..common import tools, path

CORS(app, supports_credentials=True, resources=r'/*')
# flask-CORS解决juqery的AJAX浏览器仅发送options请求，没有发送post解决方案

tool = tools.Tools()
path = path.Path()

@app.route('/api/send/file', methods=['POST'])
def upload_file():
    file = request.files.get('file') # 获取文件
    username = request.form.to_dict().get('username')
    if not username:
        return {
            'message': "用户未登录"
        }
    if file is None:
        return {
            'message': "文件上传失败"
        }
    
    file_name = file.filename
    print(file_name)
    suffix = os.path.splitext(file_name)[-1]

    nowTime = tool.getCurrentTime()
    userPath = path.userPath(username=username)

    path.makeUserDir(username=username)

    saveFilePath = path.saveFile(
        file = file,
        username = username,
        fileOldName = file_name,
        dateTime = nowTime,
        suffix = suffix
    )

	#http 路径
    url = 'http://xxxx.cn/upload/'+ saveFilePath
    print("flask get file successfully")

    return {
        'code':200,
        'messsge':"文件上传成功",
        'fileNameOld':file_name,
        'fileNameSave': saveFilePath,
        'url':url
    }


@cross_origin()
@app.route('/api/get/files', methods=['POST'])
def get_files():
    data = request.form.to_dict()
    print(data)
    username = data.get("username")
    if username == '':
        return {
            'data': []
        }
    files = path.getUserFiles(username=username)
    print(f"{username}'s file counts: " + str(len(files)))
    return {
        'data': files,
    }


@app.route('/api/auth/files', methods=['POST'])
def auth_file():
    data = request.form.to_dict()
    username = data.get("username")
    timeword = data.get("timeword")
    filepath = path.getDownLoadFilePath(username=username, timeword=timeword)
    print(f"{username}'s download file path: " + filepath)
    return {
        'data': "文件获取失败" if not filepath else filepath # 加解密
    }

@app.route('/api/download/files', methods=['GET'])
def download_file():
    filepath = request.args.get("filepath")
    return send_file(filepath, as_attachment=True)