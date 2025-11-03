FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# definie o diretorio de trabalho dentro do container
WORKDIR /src

# copia apenas os aquivos do projeto para otimizar o cache
COPY *.sln ./
COPY src/ ./app/

# restaura as dependencias
RUN dotnet restore app/web-api.csproj

# copia o restante dos aquivos do projeto
COPY . .

# compila o projeto em modo Release
RUN dotnet publish app/web-api.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime

# Define o diretório de trabalho da aplicação
WORKDIR /app

# Copia os arquivos publicados da etapa de build
COPY --from=build /app/publish .

# Configura o usuário não-root (melhor prática de segurança)
RUN adduser --disabled-password --home /app appuser
USER appuser

# Expõe a porta padrão do Kestrel
EXPOSE 8080

# Define a variável de ambiente para o ASP.NET
ENV ASPNETCORE_URLS=http://+:8080
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Define o comando de inicialização da aplicação
ENTRYPOINT ["dotnet", "web-api.dll"]