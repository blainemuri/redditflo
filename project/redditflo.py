from flask import Flask, render_template, request, url_for, abort, redirect
from uuid import uuid4
from praw.errors import HTTPException
import requests.auth, urllib, urllib.parse, json, requests, praw

app = Flask(__name__, static_folder='static')

CLIENT_ID = 'HIkG7mKev6WoNA'
CLIENT_SECRET = 'pXDTQ-whb9tQWt-QN2wBU_oHB1A'
REDIRECT_URI = "http://localhost:5000/authorize_callback"

@app.route('/')
def homepage():
  return render_template('login.html', link=make_authorization_url())

def user_agent():
  return 'Redditflo bot'

def base_headers():
    return {"User-Agent": user_agent()}

def make_authorization_url():
    # Generate a random string for the state parameter
    # Save it for use later to prevent xsrf attacks
    state = str(uuid4())
    save_created_state(state)
    params = {"client_id": CLIENT_ID,
              "response_type": "code",
              "state": state,
              "redirect_uri": REDIRECT_URI,
              "duration": "temporary",
              "scope": "identity"}
    url = "https://ssl.reddit.com/api/v1/authorize?" + urllib.parse.urlencode(params)
    return url

from flask import abort, request
@app.route('/authorize_callback')
def reddit_callback():
    error = request.args.get('error', '')
    if error:
        return "Error: " + error
    state = request.args.get('state', '')
    if not is_valid_state(state):
        # Uh-oh, this request wasn't started by us!
        abort(403)
    code = request.args.get('code')
    access_token = get_token(code)
    # We'll change this next line in just a moment
    return redirect('/homepage.html')

@app.route('/homepage.html')
def init():
  return render_template('homepage.html')

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

def get_username(access_token):
    headers = base_headers()
    headers.update({"Authorization": "bearer " + access_token})
    response = requests.get("https://oauth.reddit.com/api/v1/me", headers=headers)
    me_json = response.json()
    return me_json['name']

# Left as an exercise to the reader.
# You may want to store valid states in a database or memcache,
# or perhaps cryptographically sign them and verify upon retrieval.
def save_created_state(state):
    pass
def is_valid_state(state):
    return True


if __name__ == '__main__':
    app.run(debug=True, port=5000)

##################################################
### This is the Praw way of going about things ###

# @app.route('/')
# def initial():
#   link_refresh = r.get_authorize_url(USER_KEY, refreshable=True)
#   return render_template('login.html', link=link_refresh)

# @app.route('/authorize_callback')
# def authorized():
#   try:
#     state = request.args.get('state', '')
#     code = request.args.get('code', '')
#     info = r.get_access_information(code, update_session=True)
#     user = r.get_me()
#     variables_text = "State=%s, code=%s, info=%s." % (state, code,
#                                                       str(info))
#     text = 'You are %s and have %u link karma.' % (user.name,
#                                                    user.link_karma)
#   except HTTPException as x:
#     print(x)
#   return render_template('homepage.html')

# if __name__ == '__main__':
#   r = praw.Reddit('OAuth2 verification for use by u/blaine1726 ver 0.1 see '
#                   'https://github.com/blaine1726/redditflo for source')
#   r.set_oauth_app_info(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI)
#   app.run(debug=True, port=5000)

### End of praw example ###
###########################
