###  AWS KMS - Encrypting & Decrypting data less than and more than 4KB

###  	1. Create alias to a key already created in AWS KMS
        aws kms create-alias --alias-name alias/blahtestkey --target-key-id blahblah-bd8-009c02f41665 

###  	2. Encrypt data (<4KB)
        aws kms encrypt --key-id alias/blahtestkey  --plaintext "Hello World - I am Sensitive" --query CiphertextBlob --encryption-context UserName=heman --output text | base64 --decode > encrypted-data

###     3. Decrypt data (<4KB)
        echo “Decrypted Data: $(aws kms decrypt --ciphertext-blob fileb://encrypted-data \
	--encryption-context UserName=heman --output text --query Plaintext | base64 --decode)”
     
###     4. Generate data key to encrypt data more that 4KB. 
####    4.1 Create encrypted cipher text key
        aws kms generate-data-key --key-id=alias/blahtestkey --encryption-context UserName=heman \
	--key-spec AES_256 --output text --query CiphertextBlob | base64 --decode > EncryptedDataKey
	
####    4.2 Create plaintext version of cipher text key
        PlaintextDataKey=$(aws kms decrypt --ciphertext-blob fileb://EncryptedDataKey  \ 
	--encryption-context UserName=heman --output text --query Plaintext)

####    4.3 Encrypt data
        openssl enc -in plaintext-data.txt -out encrypted-data.txt -e -aes256 -k $PlaintextDataKey
	
###     5. Decrypt data using data-key for data more that 4KB. 
####    5.1 Create encrypted cipher text key
        aws kms generate-data-key --key-id=alias/blahtestkey --encryption-context UserName=heman \
	--key-spec AES_256 --output text --query CiphertextBlob | base64 --decode > EncryptedDataKey
	
####    5.2 Create plaintext version of cipher text key
        PlaintextDataKey=$(aws kms decrypt --ciphertext-blob fileb://EncryptedDataKey  \ 
	--encryption-context UserName=heman --output text --query Plaintext)
	
####    5.3 Decrypt data
        openssl enc -in encrypted-data.txt -out plaintext-data.txt -d -aes256 -k $PlaintextDataKey
