#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
USER app
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Vasiliev.Idp.Calculator/Vasiliev.Idp.Calculator.csproj", "Vasiliev.Idp.Calculator/"]
COPY ["Vasiliev.Idp.Dto/Vasiliev.Idp.Dto.csproj", "Vasiliev.Idp.Dto/"]
RUN dotnet restore "./Vasiliev.Idp.Calculator/./Vasiliev.Idp.Calculator.csproj"
COPY . .
WORKDIR "/src/Vasiliev.Idp.Calculator"
RUN dotnet build "./Vasiliev.Idp.Calculator.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Vasiliev.Idp.Calculator.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Vasiliev.Idp.Calculator.dll"]