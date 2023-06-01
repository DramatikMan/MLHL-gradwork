#!/bin/bash
set -e

until python -c "
import os
import socket


if __name__ == '__main__':
    for service in (
        ('s3', 9000),
        ('postgres', 5432),
        ('broker', 5672),
    ):
        print(f'Trying connection: {service}.')

        try:
            sock = socket.create_connection(service)
        except Exception:
            print(f'{service} is unavailable - sleeping.')
            raise
        else:
            print(f'Connection {service} is up.')
            sock.close()
" 2> /dev/null; do
  sleep 10
done


python -c "
import io
from pathlib import Path

import pandas as pd

from gwserver.core.s3 import s3;


s3.client.create_bucket(Bucket='gwserver')

for fname in ('database.csv',):
    with open(fname, 'rb') as handle:
        data = handle.read()
        s3.client.upload_fileobj(io.BytesIO(data), 'gwserver', fname)
        print(f'uploaded initialization asset: {fname}')

df = pd.read_csv('database.csv')

for i in df.itertuples():
    with open(i.path, 'rb') as handle:
        s3.client.upload_fileobj(handle, 'gwserver', i.path)
        print(f'uploaded dataset sample image: {i.path}')
"

gwserver init database
gwserver start api
