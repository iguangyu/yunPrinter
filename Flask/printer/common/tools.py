import time
from datetime import datetime



class Tools:
    def __init__(self) -> None:
        pass
    def getCurrentTime(self):
        return datetime.now().strftime('%Y年%m月%d日的%H时%M分%S秒')