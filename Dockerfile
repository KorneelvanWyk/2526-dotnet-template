FROM mcr.microsoft.com/dotnet/sdk:9.0

WORKDIR /app

COPY . .

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Development

ENTRYPOINT ["dotnet", "run", "--project", "src/Rise.Server/Rise.Server.csproj"]