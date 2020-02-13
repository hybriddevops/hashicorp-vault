#!/bin/bash
profile="kevin"
signed_certificate="b.temp"
echo "Username:"
read username
echo "Password:"

# Read but do not output the text written
read -s password

generate_data()
{
# Remove any empty lines from the file
 pub_cert=`sed '/^[[:space:]]$/d' $HOME/.ssh/id_rsa.pub`

# Create the json format for the request 
 cat << END
 {"public_key" : "$pub_cert"}
END
}

# Call the login api endpoint and retrieve only the token

VAULT_TOKEN=`curl -s -k $VAULT_ADDR/v1/auth/userpass/login/$username -d "{\"password\": \"$password\"}" -X POST | jq -r '.auth.client_token'`

#remove the -k if your systems trusts the vault certificate

curl -s -k -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/ssh-client-signer/sign/$profile -d "$(generate_data)" -X POST| jq -r '.data.signed_key' > $signed_certificate

#remove the \n that is generated with the key signing response
sed -i -e  '/^$/d' $signed_certificate

# Display to make sure file is good
ssh-keygen.exe -Lf $signed_certificate
