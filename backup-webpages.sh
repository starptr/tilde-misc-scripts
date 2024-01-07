#!/usr/bin/env nix-shell
#! nix-shell -i python3.11 -p python3

import glob
import subprocess
import re
from datetime import datetime

date = datetime.today().strftime('%Y-%m-%d')
cur_root = f'/webpage_backups/{date}'

public_html_paths = glob.glob('/home/*/public_html')
username_regcompiled = re.compile(r'^\/home\/([^\/\\]+)\/')

for public_html_path in public_html_paths:
    username_regresult = username_regcompiled.search(public_html_path)
    username = username_regresult.group(1)

    ipfs_mfs_path = f'{cur_root}/public_htmls/{username}/'

    subprocess.run(['ipfs',
                    'files',
                    'mkdir',
                    '--parents',
                    f'{ipfs_mfs_path}'])

    subprocess.run(['ipfs',
                    'add',
                    '--pin',
                    '--recursive',
                    f'{public_html_path}',
                    '--to-files',
                    f'{ipfs_mfs_path}'])

other_paths = ['/home/starptr/src/tilde-homepage/tilde',
            '/home/starptr/src/tilde-homepage/root',
            '/home/starptr/status-ref/build_html']
other_mfs_rename = ['tilde_homepage',
                    'homepage',
                    'status_coffee']

for idx in range(len(other_paths)):
    other_path = other_paths[idx]
    other_mfs_prefix = other_mfs_rename[idx]
    ipfs_mfs_path = f'{cur_root}/{other_mfs_prefix}/'

    subprocess.run(['ipfs',
                    'files',
                    'mkdir',
                    '--parents',
                    f'{ipfs_mfs_path}'])

    subprocess.run(['ipfs',
                    'add',
                    '--pin',
                    '--recursive',
                    f'{other_path}',
                    '--to-files',
                    f'{ipfs_mfs_path}'])