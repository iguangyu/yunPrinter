# from calendar import calendar
import calendar
import time
from main import app
from flask import request
import os

@app.route('/api/get/user', methods=['POST'])
def getUserInfo():
    username = ''
    password = ''
    