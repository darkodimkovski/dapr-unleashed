#Install Dapr cli

winget install Dapr.CLI

# Initialize Dapr runtime

dapr init 

# Run .NET app

cd /c/Users/ddi/source/repos/dapr-unleashed/source/daprunleashed.ingestionservice/
dapr run --app-id dapr-app --dapr-http-port 3500 dotnet run

# Run node app

cd /c/Users/ddi/source/repos/node-hello/
dapr run --app-id hello-node --dapr-http-port 3501 npm start

# Run dapr dashboard

dapr dashboard