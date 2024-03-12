#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
ENV DOTNET_URLS=http://+:8080
WORKDIR /src
COPY ["Vasiliev.Idp.Orchestrator/Vasiliev.Idp.Orchestrator.csproj", "Vasiliev.Idp.Orchestrator/"]
RUN dotnet restore "./Vasiliev.Idp.Orchestrator/./Vasiliev.Idp.Orchestrator.csproj"
COPY . .
WORKDIR "/src/Vasiliev.Idp.Orchestrator"
RUN dotnet build "./Vasiliev.Idp.Orchestrator.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Vasiliev.Idp.Orchestrator.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Vasiliev.Idp.Orchestrator.dll"]