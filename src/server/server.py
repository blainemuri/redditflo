from flask import Flask, render_template, request, url_for, abort, redirect
from uuid import uuid4
from praw.errors import HTTPException
import requests.auth, urllib, urllib.parse, json, requests, praw, webbrowser
import json

app = Flask(__name__, static_folder='static')

# Constants

PORT = 3000
CLIENT_ID = 'HIkG7mKev6WoNA'
CLIENT_SECRET = 'pXDTQ-whb9tQWt-QN2wBU_oHB1A'
REDIRECT_URI = "http://localhost:{}/authorize_callback".format(PORT)
access_token = ''
authorization_url = ''
username = ''

# Helpers

def save_json(obj, fname):
    json.dump(obj, open(fname, 'w'))

def read_json(fname):
    return json.load(open(fname, 'r'))

# Authorization

def user_agent():
    return 'Redditflo app'

def base_headers():
    return {"User-Agent": user_agent()}

def make_authorization_url():
    # Generate a random string for the state parameter
    # Save it for use later to prevent xsrf attacks
    state = str(uuid4())
    params = {
        "client_id": CLIENT_ID,
        "response_type": "code",
        "state": state,
        "redirect_uri": REDIRECT_URI,
        "duration": "permanent",
        "scope": "identity"
    }
    url = "https://ssl.reddit.com/api/v1/authorize?" + urllib.parse.urlencode(params)
    return url

def get_token(code):
    client_auth = requests.auth.HTTPBasicAuth(CLIENT_ID, CLIENT_SECRET)
    post_data = {"grant_type": "authorization_code",
                 "code": code,
                 "redirect_uri": REDIRECT_URI}
    headers = base_headers()
    response = requests.post("https://ssl.reddit.com/api/v1/access_token",
                             auth=client_auth,
                             headers=headers,
                             data=post_data)
    token_json = response.json()
    return token_json["access_token"]

# Routes

@app.route('/authorization_url')
def route_authorization_url():
    global authorization_url
    return json.dumps({'url': authorization_url})

@app.route('/authorize_callback')
def route_reddit_callback():
    global access_token
    error = request.args.get('error', '')
    if error:
        return "Error: " + error
    state = request.args.get('state', '')
    code = request.args.get('code')
    access_token = get_token(code)
    # We'll change this next line in just a moment
    return 'Authenticated'

@app.route('/subscriptions')
def route_subs():
    global username
    if username is '':
        return '{}'
    else:
        return json.dumps(read_json('{}.json'.format(username)))

@app.route('/token')
def route_token():
    global access_token
    return json.dumps({'token': access_token})

@app.route('/username')
def route_username():
    global access_token, username
    if username is '' and access_token != '':
        headers = base_headers()
        headers.update({"Authorization": "bearer " + access_token})
        response = requests.get("https://oauth.reddit.com/api/v1/me", headers=headers)
        me_json = response.json()
        username = me_json['name']
    return json.dumps({'username': username})

@app.route('/reset_token')
def route_reset_token():
    global access_token, username
    access_token = ''
    username = ''
    return 'ok'

# Main
if __name__ == '__main__':
    global authorization_url
    authorization_url = make_authorization_url()
    webbrowser.open(authorization_url, 1, True)
    app.run(debug=True, port=PORT)
