# Usa uma imagem oficial do Python mais leve, baseada no Debian Bookworm
FROM python:3.11-slim-bookworm

# Define a variável de ambiente para forçar o Playwright a instalar 
# os navegadores em um diretório fixo e acessível globalmente
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Instala ferramentas básicas de sistema
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho
WORKDIR /app

# Copia o arquivo de requisitos primeiro para aproveitar o cache do Docker
COPY requirements.txt .

# Instala as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Passo crucial: Instala as dependências de sistema do Chromium E o próprio navegador
RUN playwright install-deps chromium && \
    playwright install chromium

# Copia o resto dos arquivos da aplicação
COPY . .

# Cria a pasta de downloads para evitar erros de permissão ou caminho inexistente
RUN mkdir -p downloads

# Dá permissão de execução para o script de inicialização
RUN chmod +x entrypoint.sh

# Expõe a porta que será usada
ENV PORT=8080
EXPOSE 8080

# Inicia a aplicação usando o script fornecido
CMD ["/bin/bash", "entrypoint.sh"]
