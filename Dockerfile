# <https://hub.docker.com/_/microsoft-dotnet-core>
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY JankinstestMVC /*.csproj ./JankinstestMVC/
RUN dotnet restore -r linux-musl-x64


# copy everything else and build app
COPY JankinstestMVC/. ./JankinstestMVC/
WORKDIR /source/JankinstestMVC
RUN dotnet publish -c release -o /app -r linux-musl-x64 --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
WORKDIR /app
COPY --from=build /app ./

ENTRYPOINT ["./JankinstestMVC"]
