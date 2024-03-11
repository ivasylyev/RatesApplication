#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
USER app
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Vasiliev.Idp.Command/Vasiliev.Idp.Command.csproj", "Vasiliev.Idp.Command/"]
COPY ["Vasiliev.Idp.Dto/Vasiliev.Idp.Dto.csproj", "Vasiliev.Idp.Dto/"]
RUN dotnet restore "./Vasiliev.Idp.Command/./Vasiliev.Idp.Command.csproj"
COPY . .
WORKDIR "/src/Vasiliev.Idp.Command"
RUN dotnet build "./Vasiliev.Idp.Command.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Vasiliev.Idp.Command.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Vasiliev.Idp.Command.dll"]