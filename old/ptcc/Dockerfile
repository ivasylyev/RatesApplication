# http
#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
FROM repo.dev002.local/mcr.microsoft.com/dotnet/sdk:6.0 AS build
#WORKDIR /app
#EXPOSE 80
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nodejs \
    npm

# copy csproj and restore as distinct layers
WORKDIR /cache
COPY */*.csproj ./
COPY NuGet.config ./
RUN find . -name '*.csproj' -exec dotnet restore {} \;

WORKDIR /solution
COPY ./ ./
RUN dotnet restore
#RUN dotnet test
RUN dotnet publish -c release -o ./artifacts --no-restore

# final stage/image
FROM repo.dev002.local/mcr.microsoft.com/dotnet/aspnet:6.0
COPY --from=build /solution/artifacts ./
ENTRYPOINT ["dotnet", "Sibur.Digital.Svt.PTCC.App.dll"]

#FROM repo.dev002.local/mcr.microsoft.com/dotnet/sdk:6.0 AS build