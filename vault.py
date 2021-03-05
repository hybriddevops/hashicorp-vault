import getpass
import json
import requests
import os

base = os.getenv('VAULT_ADDR')
auth = "{0}/auth/userpass/login".format(base)
username = ""

def login_vault():
    obj = {}
    username = raw_input("Please input username: ")
    obj['password'] = getpass.getpass()
    payload = json.dumps(obj)  # type: str
    response = requests.post("{0}/{1}".format(auth, username),data = payload)
    return json.loads(response.text)

def sign_key():

    data = {'public_key': read_pubkey()}
    response = requests.post('https://jsonplaceholder.typicode.com/posts', data)
    print(response.status_code)
    print(response.text)

def main():
    print("vault.py")

if __name__ == '__main__':
    main()