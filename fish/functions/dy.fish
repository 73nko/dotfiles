function dy --description 'Start DynamoDB Local'
    set -l DYNAMO_DIR "$HOME/Library/Mobile Documents/com~apple~CloudDocs/dynamo"
    java --enable-native-access=ALL-UNNAMED \
        -Djava.library.path="$DYNAMO_DIR/DynamoDBLocal_lib" \
        -jar "$DYNAMO_DIR/DynamoDBLocal.jar" \
        -dbPath "$DYNAMO_DIR/" \
        -sharedDb
end
