Relatório do Projeto A: Implantação de infraestrutura de serviços web utilizando ferramentas de virtualização

Introdução
Neste projeto temos como objetivo configurar uma infraestrutura de serviços web utilizando ferramentas de virtualização (VirtualBox e Vagrant), balanceamento de carga, servidores web, banco de dados PostgreSQL com replicação mestre-escravo e servidor WebSocket. A infraestrutura sera projetada para garantir redundância, escalabilidade e alta disponibilidade.

Componentes da Infraestrutura
A infraestrutura sera composta pelos seguintes componentes:

























Configuração do Balanceamento de Carga com nginx
Definição do Balanceador de Carga:

No Vagrant, configuramos um terceiro servidor virtual chamado loadbalancer.
Este servidor foi configurado com o nginx como software de balanceamento de carga.
Recebeu um endereço IP privado (192.168.44.12) para comunicação na rede interna.
Instalação e Configuração do nginx:

Dentro do provisionamento shell para o loadbalancer, instalamos o nginx com os comandos:

sudo apt-get update
sudo apt-get install -y nginx
Configuramos o nginx para encaminhar o tráfego para os servidores web web1 e web2

Criamos um arquivo de configuração loadbalancer.conf para o nginx:
upstream app_servers: Define um grupo de servidores upstream onde o nginx encaminhará as requisições.
server { ... }: Configura um servidor virtual nginx na porta 80 que encaminha todas as requisições para http://app_servers, que representa o grupo app_servers definido anteriormente.

Restart do nginx:

Após configurar o arquivo loadbalancer.conf, reiniciamos o nginx para aplicar as alterações:
sudo systemctl restart nginx


Funcionamento do Balanceamento de Carga
Balanceamento de Carga: Com essa configuração, o nginx atua como um balanceador de carga distribuindo o tráfego recebido na porta 80 entre os servidores web1 e web2.
Proxy Pass: A diretiva proxy_pass http://app_servers; dentro do bloco location / no arquivo loadbalancer.conf instrui o nginx a enviar todas as solicitações HTTP recebidas para o grupo app_servers, que contém os endereços IP dos servidores web1 e web2.

Configuração dos Servidores Web (web1 e web2)
Definição dos Servidores Web no Vagrant:

Utilizamos o Vagrant para definir dois servidores virtuais (web1 e web2) baseados na imagem ubuntu/bionic64.
Cada servidor recebeu um endereço IP privado na rede interna 
	192.168.44.10 para web1  
	192.168.44.11 para web2

Apache (apache2): Servidor web popular usado para servir páginas web
Configuração do Conteúdo Estático:
Para cada servidor web, criamos um arquivo index.html básico na pasta /var/www/html/ com uma mensagem para identificar o servidor:Isso garante que cada servidor web tenha um conteúdo único para fins de identificação durante o teste e a operação
Essa configuração básica de balanceamento de carga é adequada para distribuir solicitações HTTP simples entre servidores web, permitindo que o sistema seja escalável e resiliente a falhas.



Configuraçao do arquivo .env
Web1
 
Web2
 
Funcionamento do db-master & db-slave

A configuração master-slave (ou principal-secundário) no banco de dados é uma forma de replicação de dados onde um servidor principal (master) é responsável pelas operações de escrita e um ou mais servidores secundários (slaves) replicam essas operações e geralmente lidam com operações de leitura. 


Funcionamento de Server NFS
O servidor nfs servira de ponte entre web1 e web2, porque imaginemos que o cliente e redirecionado para we1 e faz o upload duma imagem, esta imagem não sera visto no web2 e vice verça.
Para evitar isso precisamos dum servidor que terá uma pasta de partilha e configurações (permissões) de acesso a pasta para os endereços do web1 e web2.
E o upload passera a ser o servidor nfs e não no web1 ou web1
