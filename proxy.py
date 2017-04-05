from __future__ import print_function

import urllib
import httplib
import os

TARGET_SERVER = os.environ['webserver_internal_ip']

def lambda_handler(event, context):

    if 'queryStringParameters' in event.keys() and event.get('queryStringParameters'):
        queryParams = event.get('queryStringParameters')
    else:
        queryParams = {}

    if 'headers' in event.keys() and event.get('headers'):
        headerValues = event.get('headers')
    else:
        headerValues = {}

    target_server_connection = httplib.HTTPConnection(TARGET_SERVER)
    target_server_connection.request(event['httpMethod'],
                                     event['path'],
                                     urllib.urlencode(queryParams),
                                     headerValues)

    target_server_response = target_server_connection.getresponse()

    target_server_output = {}

    target_server_output['statusCode'] = target_server_response.status
    target_server_output['body'] = target_server_response.read()
    target_server_output['headers'] = dict((key, value) for key, value in target_server_response.getheaders())

    return target_server_output