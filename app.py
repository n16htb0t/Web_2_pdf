from flask import Flask, render_template, request, redirect, url_for
import subprocess
import threading
import time

app = Flask(__name__)

def run_script(url):
    # Run bash script with URL as argument
    subprocess.Popen(['./check.sh', url])

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        url = request.form['url']
        # Send URL as webhook (You need to implement webhook functionality)
        # For demonstration purpose, let's just print the URL
        print("Received URL:", url)

        # Start a new thread to run the script
        thread = threading.Thread(target=run_script, args=(url,))
        thread.start()

        # Redirect to success page after a delay
        time.sleep(5)
        return redirect(url_for('success'))

    # Render index.html
    return render_template('index.html')

@app.route('/success')
def success():
    # GitHub link for the results
    github_url = "https://github.com/n16htb0t/output.txt"
    # Render success.html with GitHub URL
    return render_template('success.html', github_url=github_url)

if __name__ == '__main__':
    app.run(debug=True)
