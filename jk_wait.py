#!/usr/bin/env python

import re
import sys
from datetime import datetime, timedelta
import time

reg_exp = re.compile(r'\d+h\d+m|\d{2}:\d{2}|\d+m|\d+h')
reg_split = re.compile(r'm|h|:')

def make_time(t):
    ma = reg_exp.search(t)
    if ma:
        data = ma.group()
        out = reg_split.split(data)
        target = datetime.now()
        delta = None
        if ":" in data: # hh:mm format
            target = target.replace(hour=int(out[0]), minute=int(out[1]))
        else:
            hour, minute = 0, 0
            if len(out) > 2:
                hour = int(out[0])
                minute = int(out[1])

            else:
                if data.endswith("h"):
                    hour = int(out[0])
                else:
                    minute = int(out[0])
            delta = timedelta(hours=hour, minutes=minute)
            target += delta
        return target

def wait_unit(t, check_interval = 3* 60):
    target = make_time(t)
    print("Compile will start at: %s "%target)
    while True:
        now = datetime.now()
        if (target - now).total_seconds() <= 0:
            print("Time comes: [%s]"%now)
            break
        time.sleep(check_interval)
        print("Now:[%s] sleep"%now)

#wait_unit('1m', check_interval=10)

if __name__ == '__main__':
	if len(sys.argv) >= 2:
		wait_unit(sys.argv[1])