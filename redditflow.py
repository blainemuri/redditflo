from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/reddit')
def reddit():
    return '''
        <!DOCTYPE html PUBLIC "-//IETF//DTD HTML 2.0//EN">
        <HTML>
           <HEAD>
              <TITLE>
                 A Small Hello
              </TITLE>
           </HEAD>
        <BODY>
           <H1>Hi</H1>
           <P>This is very minimal "hello world" HTML document.</P>
        </BODY>
        </HTML>
    '''

if __name__ == '__main__':
    app.run()
