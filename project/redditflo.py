from flask import Flask, render_template, request, url_for, abort
from uuid import uuid4
import requests.auth, urllib, urllib.parse, json, requests, praw

app = Flask(__name__, static_folder='static')

CLIENT_ID = 'HIkG7mKev6WoNA'
CLIENT_SECRET = 'pXDTQ-whb9tQWt-QN2wBU_oHB1A'
REDIRECT_URI = "http://localhost:5000/homepage.html"

@app.route('/')
def homepage():
  key = str(uuid4())
  link_refresh = r.get_authorize_url(key, refreshable=True)
  return render_template('login.html', link=link_refresh)

@app.route('/homepage.html')
def authorized():
  state = request.args.get('state', '')
  code = request.args.get('code', '')
  info = r.get_access_information(code)
  user = r.get_me()
  variables_text = "State=%s, code=%s, info=%s." % (state, code,
                                                    str(info))
  text = 'You are %s and have %u link karma.' % (user.name,
                                                 user.link_karma)
  return render_template('/homepage.html')

if __name__ == '__main__':
  r = praw.Reddit('OAuth2 verification for use by u/blaine1726 ver 0.1 see '
                  'https://github.com/blaine1726/redditflo for source')
  r.set_oauth_app_info(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI)
  app.run(debug=True, port=5000)

# @app.route('/')
# def login():
#   r = praw.Reddit('OAuth2 verification for use by u/blaine1726 ver 0.1 see '
#                   'https://github.com/blaine1726/redditflo for source')
#   r.set_oauth_app_info(client_id= CLIENT_ID,
#                        client_secret= CLIENT_SECRET,
#                        redirect_uri= REDIRECT_URI)
#   url = r.get_authorize_url('uniqueKey', 'identity', True)
#   import webbrowser
#   webbrowser.open(url)

#   state = str(uuid4())
#   access_information = r.get_access_information(state)

#   r.set_access_credentials(**access_information)

#   authenticated_user = r.get_me()
#   print(authenticated_user.name, authenticated_user.link_karma)

#   return REDIRECT_URI
#   # text = '<a href="%s">Authenticate with reddit</a>'
#   # return(text % make_authorization_url())
#   #return render_template('homepage.html')

# #def make_authorization_url():
#     # Generate a random string for the state parameter
#     # Save it for use later to prevent xsrf attacks
#     # state = str(uuid4())
#     # save_created_state(state)
#     # params = {"client_id": CLIENT_ID,
#     #           "response_type": "code",
#     #           "state": state,
#     #           "redirect_uri": REDIRECT_URI,
#     #           "duration": "temporary",
#     #           "scope": "identity"}
#     # url = "https://ssl.reddit.com/api/v1/authorize?" + urllib.parse.urlencode(params)
#     # return url

# @app.route('/homepage.html')
# def homepage():
#   # error = request.args.get('error', '')
#   # if error:
#   #     return "Error: " + error
#   # state = request.args.get('state', '')
#   # if not is_valid_state(state):
#   #     # Uh-oh, this request wasn't started by us!
#   #     abort(403)
#   # code = request.args.get('code')
#   #print(code)
#   #access_token = get_token(code)
#   #print('Access Token: ', access_token)
#   return render_template('homepage.html')

# # def get_token(code):
# #     client_auth = requests.auth.HTTPBasicAuth(CLIENT_ID, CLIENT_SECRET)
# #     print(requests.auth.HTTPBasicAuth(CLIENT_ID, CLIENT_SECRET))
# #     post_data = {"grant_type": "authorization_code",
# #                  "code": code,
# #                  "redirect_uri": REDIRECT_URI}
# #     response = requests.post("https://ssl.reddit.com/api/v1/access_token",
# #                              auth=client_auth,
# #                              data=post_data)
# #     print(response.json())
# #     token_json = response.json()
# #     return token_json["access_token"]

# # def get_username(access_token):
# #   headers = {"Authorization": "bearer " + access_token}
# #   response = requests.get("https://oauth.reddit.com/api/v1/me", headers=headers)
# #   me_json = response.json()
# #   return me_json['name']

# # # Left as an exercise to the reader.
# # # You may want to store valid states in a database or memcache,
# # # or perhaps cryptographically sign them and verify upon retrieval.
# # def save_created_state(state):
# #     pass
# # def is_valid_state(state):
# #     return True

# # @app.route('/login', methods=['GET', 'POST'])
# # def login():
# #   username = request.json['username']
# #   password = request.json['password']
# #   client_auth = requests.auth.HTTPBasicAuth(client_id, secret)
# #   post_data = {"grant_type": "password", "username": username, "password": password}
# #   headers = {"User-Agent": "redditflo/0.1 by blaine1726"}
# #   response = requests.post("https://www.reddit.com/api/v1/access_token", auth=client_auth, data=post_data, headers=headers)
# #   print(response.json())
# #   return render_template('homepage.html')

# if __name__ == '__main__':
#     app.run(debug=True, port=5000)
