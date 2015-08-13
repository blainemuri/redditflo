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
r = ''

# Helpers

def save_json(obj, fname):
    json.dump(obj, open(fname, 'w'), indent=4, sort_keys=True)

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
        "scope": "identity vote"
    }
    url = "https://ssl.reddit.com/api/v1/authorize?" + urllib.parse.urlencode(params)
    return url

def get_token(code):
    # print('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
    # print('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
    # print('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
    # print('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$')
    # r = praw.Reddit('Redditflo upvoting app to help users follow other users')
    # r.set_oauth_app_info(client_id=CLIENT_ID,
    #                      client_secret=CLIENT_SECRET,
    #                      redirect_uri=REDIRECT_URI)
    # access_information = r.get_access_information(code)
    # print(**access_information)
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

@app.route('/')
def route_authorize_page():
    return redirect(authorization_url)

@app.route('/authorization_url')
def route_authorization_url():
    global authorization_url
    return json.dumps({'url': authorization_url})

@app.route('/authorize_callback')
def route_reddit_callback():
    global access_token
    if access_token != '':
        return 'Cannot authenticate more than one user at a time!'
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

@app.route('/upvote')
def upvote():
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    print('##################################################################################')
    global access_token, username, CLIENT_ID, CLIENT_SECRET, REDIRECT_URI, r
    r = praw.Reddit('Redditflo upvoting app')
    r.set_oauth_app_info(client_id=CLIENT_ID,
                         client_secret=CLIENT_SECRET,
                         redirect_uri=REDIRECT_URI)
    r.set_access_credentials(**{'scope': {'identity', 'vote'}, 'access_token': access_token})
    post = r.get_submission(submission_id='3gu6pa')
    post.upvote()
    print(r.has_scope('vote'))
    #response = post.upvote()
    #print(response)
    #post.upvote()
    # if access_token != '':
    #     headers = base_headers()
    #     headers.update({"Authorization": "bearer" + access_token, "dir": "1", "id": "t3_3gqgum"})
    #     response = requests.post("https://oath.reddit.com/api/vote", headers=headers, dir=1)
    #     me_json = response.json()
    #     print(me_json)
    return json.dumps({"hello": "hello"})

@app.route('/reset_token')
def route_reset_token():
    global access_token, username, authorization_url
    access_token = ''
    username = ''
    authorization_url = make_authorization_url()
    return redirect("http://localhost:{}/token".format(PORT))

@app.route('/update_subscriptions')
def route_update_subs():
    subscriptions = json.loads(request.args.get('subscriptions'))
    save_json({'subscriptions': subscriptions}, '{}.json'.format(username))
    return ''

# Main
if __name__ == '__main__':
    global authorization_url
    authorization_url = make_authorization_url()
    app.run(debug=True, port=PORT)
