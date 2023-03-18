import os
from printer import app
import operator


class Path:
    def __init__(self) -> None:
        self.UPLOAD = app.config['UPLOAD_FOLDER']
        self.UPLOAD_PATH = os.path.abspath(self.UPLOAD)

    def userPath(self, username):
        return os.path.join(self.UPLOAD_PATH, username)

    def userPathExist(self, username):
        return os.path.exists(self.userPath(username=username))

    def makeUserDir(self, username):
        if not self.userPathExist(username=username):
            os.mkdir(self.userPath(username=username))
        return True

    def saveFile(self, file, username, fileOldName, dateTime, suffix):
        saveFilePath = os.path.join(self.userPath(username=username), f"{dateTime}-{fileOldName}")
        file.save(
            saveFilePath
        )
        return saveFilePath
    
    def getUserFiles(self, username):
        self.makeUserDir(username=username)
        files = os.listdir(self.userPath(username=username))
        return files

    def getDownLoadFilePath(self, username, timeword):
        files = self.getUserFiles(username=username)
        for file in files:
            if operator.contains(file, timeword):
                filepath = os.path.join(self.userPath(username=username), file)
                return filepath if os.path.isfile(filepath) else None
        return None

if __name__ == '__main__':
    pa = Path()
    # pa.makeUserDir('aaaaddadd')
    pa.getDownLoadFilePath(username='adf', timeword='2023')
