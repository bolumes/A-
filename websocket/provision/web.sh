#!/bin/bash
MSG_COLOR="\033[41m"

# Função para mostrar mensagens com cor
print_message() {
    echo -e "$MSG_COLOR$(hostname): $1\033[0m"
}

print_message "Update package lists"
sudo apt-get update

print_message "Install Apache HTTP Server"
sudo apt-get install -y apache2

print_message "Install PHP 8.1"
# Instalação do PHP 8.1 e módulos essenciais
sudo apt install -y --no-install-recommends php8.1

print_message "Install additional PHP 8.1 modules"
sudo apt-get install -y \
    php8.1-cli \
    php8.1-common \
    php8.1-mysql \
    php8.1-pdo \
    php8.1-zip \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-curl \
    php8.1-xml \
    php8.1-bcmath \
    zip \
    unzip

# Reinicia o Apache para aplicar as mudanças
sudo systemctl restart apache2

print_message "Install Composer (PHP)"
# Baixa e instala o Composer
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

print_message "Install dependencies for WebSocket server"
# Instala as dependências do servidor WebSocket
cd /vagrant/ws
sudo -u vagrant bash -c 'composer install'

print_message "Finished! Apache and PHP are installed, WebSocket server dependencies are set up."
