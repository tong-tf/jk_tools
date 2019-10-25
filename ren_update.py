#!/usr/bin/env python3

"""
此脚本用来对update进行重命名功能，要配合脚本目录下的client.yml文件来查询客户信息本脚本接收三个参数
@ $1 客户名字
＠ $2 cpu名称
＠ $3 项目名字
"""
import os
import sys
import yaml
from subprocess import check_output
from datetime import datetime

config=os.path.join(os.path.dirname(__file__), 'client.yml')


def main():
	name = sys.argv[1]
	cpu = sys.argv[2]
	prj = sys.argv[3]
	with open(config, encoding='utf8') as fp:
	    data = yaml.load(fp)
	for client in data['client']:
	    if client['name'] ==  name and client['cpu'] == cpu.upper() :
	        rv = '_'.join(client.values())
	        rv = check_output(['cp', f'rockdev/Image-{prj}/update.img',
	        	f'../ROM/{rv}-{datetime.now().strftime("%Y%m%d")}.img'])
	        print(rv)

if __name__ == '__main__':
	main()