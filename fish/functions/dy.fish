function dy --description 'Start DynamoDB Local'
    java --enable-native-access=ALL-UNNAMED \
        -Djava.library.path="$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo/DynamoDBLocal_lib" \
        -jar "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo/DynamoDBLocal.jar" \
        -dbPath "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo/" \
        -sharedDb
end
