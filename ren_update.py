#!/usr/bin/env python3

"""脚本用来对update进行重命名功能，要配合脚本目录下的client.yml文件来查询客户信息
Usage:
	ren_update.py CLIENT CPU [PROJECT]

Arguments:
	CLIENT  客户名字简称
	CPU  cpu名称 rk3288, rk3399
	PROJECT  编译的项目名称，如果不指定则和cpu相同

Options:
	-h --help  show this message
"""
import os
import sys
import yaml
from subprocess import check_output
from datetime import datetime
from docopt import docopt

config=os.path.join(os.path.dirname(__file__), 'client.yml')


def main(args):
	print(args)
	name = args['CLIENT']
	cpu = args['CPU']
	prj = args['PROJECT'] if args['PROJECT'] else cpu
	with open(config, encoding='utf8') as fp:
	    data = yaml.load(fp)
	for client in data['client']:
	    if client['name'] ==  name and client['cpu'] == cpu.upper() :
	        rv = '_'.join(client.values())
	        rv = check_output(['cp', '-v', f'rockdev/Image-{prj}/update.img',
	        	f'../ROM/{rv}-{datetime.now().strftime("%Y%m%d")}.img'])
	        if rv:
	        	print(rv.decode('utf8'))

if __name__ == '__main__':
	main(docopt(doc=__doc__))