dapr run --app-id ingestion --dapr-http-port 3500 dotnet run
cd ../DaprUnleashed.TransformationService/
dapr run --app-id transformation --dapr-http-port 3501 dotnet run