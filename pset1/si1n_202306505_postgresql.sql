---Segmento inicial---

     --Excluir o banco de dados caso ele já exista--

          DROP DATABASE IF EXISTS uvv;
         
     --Excluir o usuário caso ele já exista--
            
          DROP USER IF EXISTS rakel;
         
     --Criar o usuário responsável por ser o ´´dono´´ do banco de dados--
           
          CREATE USER rakel WITH   
          CREATEDB   
          CREATEROLE
          INHERIT
          ENCRYPTED PASSWORD 'rakel';
         
         
     --Usando o usuário para criar o banco de dados--    
         
          SET ROLE rakel;
         
     -- Criando o banco de dados uvv--
             
          CREATE DATABASE uvv WITH
          --OWNER = 'rakel'--
          TEMPLATE = 'template0'
          ENCODING = 'UTF8'
          LC_COLLATE = 'pt_BR.UTF-8'
          LC_CTYPE = 'pt_BR.UTF-8'
          ALLOW_CONNECTIONS = 'true'
           OWNER = 'rakel';
     
      --Comando para utilizar o banco de dados uvv--
          \c uvv;
         
          SET ROLE rakel;

          SELECT CURRENT_user;
         
     --Criar o schema lojas--
          CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION rakel;

     --Definir a ordem padrão dos esquemas--
          ALTER USER rakel 
          SET SEARCH_PATH TO lojas,"&user", public; 

---Segmento inicial concuído---


/*  
Início do segundo segmento

Nesse bloco todas as tabelas e colunas serão criadas, assim como suas chaves primárias, estrangeiras e restrições de checagem.
*/


COMMENT ON DATABASE UVV IS 'Banco de dados para gerenciamento de uma rede de lojas da Universidade de Vila Velha';

-- Criando a tabela produtos juntamente com suas colunas--
         

CREATE TABLE lojas.produtos (
                produto_id                            NUMERIC(38) NOT NULL,
                nome                                  VARCHAR(255) NOT NULL,
                preco_unitario                        NUMERIC(10,2),
                detalhes                              BYTEA,
                imagem                                BYTEA,
                imagem_mime_type                      VARCHAR(512),
                imagem_arquivo                        VARCHAR(512),
                imagem_charset                        VARCHAR(512),
                imagem_ultima_atualizacao             DATE,
                
                --Chave primária da tabela produtos--
                
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id),
                
                --Restrição de checagam para garantir que o preço do produto seja positivo--
                
                CONSTRAINT check_preco_unitario_nao_negativo CHECK (preco_unitario >= 0)
);

-- Comentários da tabela produtos e de suas colunas--

COMMENT ON TABLE lojas.produtos                            IS 'Tabela para armazenar os dados de cada produto.';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'Chave primaria da tabela produtos, identifica a numeracao para cada produto.';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Nome de cada produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Preco de cada produto.';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Detalhes de cada produto';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Imagem de cada produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'Armazena a categoria do documento da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'Armazena o aquivo da imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Armazena o formato de codificacao dos caracteres da imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Armazena a data da ultima atualizacao da imagem do produto.';


--Criando a tabela lojas juntamente com suas colunas--


CREATE TABLE lojas.lojas (
                loja_id                  NUMERIC(38) NOT NULL,
                nome                     VARCHAR(255) NOT NULL,
                endereco_web             VARCHAR(100),
                endereco_fisico          VARCHAR(512),
                latitude                 NUMERIC,
                longitude                NUMERIC,
                logo                     BYTEA,
                logo_mime_type           VARCHAR(512),
                logo_arquivo             VARCHAR(512),
                logo_charset             VARCHAR(512),
                logo_ultima_atualizacao  DATE,
                
                --Chave primária da tabela lojas--
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id),
                
                --Restrição de checagam para garantir que pelo menos uma das colunas de endereço (web ou físico) sejam preenchidas--
                
                CONSTRAINT check_endereco_lojas CHECK ((endereco_web IS NOT NULL) OR (endereco_fisico IS NOT NULL))
                        
);

--Comentários da tabela lojas e de suas colunas--

COMMENT ON TABLE lojas.lojas                           IS 'Tabela que armazena os dados de cada loja UVV';
COMMENT ON COLUMN lojas.lojas.loja_id                  IS 'Numero para identificacao de cada loja cadastrada.';
COMMENT ON COLUMN lojas.lojas.nome                     IS 'Contem o nome de cada loja';
COMMENT ON COLUMN lojas.lojas.endereco_web             IS 'Endereco de web da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico          IS 'Endereco fisico onde cada loja fica localizada';
COMMENT ON COLUMN lojas.lojas.latitude                 IS 'Coluna para armazenar a latitude, ou seja, distancia em graus entre qualquer ponto na superficie terrestre e a linha do equador.';
COMMENT ON COLUMN lojas.lojas.longitude                IS 'Coluna para armazenar a longitude, ou seja, a medida em graus de qualquer ponto da superficie terrestre ate o meridiano de greenwich';
COMMENT ON COLUMN lojas.lojas.logo                     IS 'Armazena a logo de cada loja.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type           IS 'Armazena a categoria do documento da logo.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo             IS 'Armezena o arquivo da logo.';
COMMENT ON COLUMN lojas.lojas.logo_charset             IS 'Armazena o formato de codificacao de caracteres da logo.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao  IS 'Data da ultima atualizacao da logo da loja.';


--Criando a tabela estoques juntamente com suas colunas--

CREATE TABLE lojas.estoques (
                estoque_id        NUMERIC(38) NOT NULL,
                loja_id           NUMERIC(38) NOT NULL,
                produto_id        NUMERIC(38) NOT NULL,
                quantidade        NUMERIC(38) NOT NULL,
                
                --Chave primária da tabela estoques--
                  CONSTRAINT pk_estoques PRIMARY KEY (estoque_id),
                
                --Restrição de checagam para garantir que a quantidade seja positiva--
        
                  CONSTRAINT check_quantidade_nao_negativa CHECK (quantidade >= 0)

);

--Comentários da tabela estoques e de suas colunas--

COMMENT ON TABLE lojas.estoques              IS 'Tabela para registrar dados do estoque de cada produto.';
COMMENT ON COLUMN lojas.estoques.estoque_id  IS 'Chave primaria da tabela estoques.';
COMMENT ON COLUMN lojas.estoques.loja_id     IS 'Chave estrangeira para identificar de qual loja se trata o produto em estoque.';
COMMENT ON COLUMN lojas.estoques.produto_id  IS 'Chave estrangeira para identificar os dados de determinado produto no estoque.';
COMMENT ON COLUMN lojas.estoques.quantidade  IS 'Quantidade de produtos em estoque';

--Criando a tabela clientes juntamente com suas colunas--

CREATE TABLE lojas.clientes (
                cliente_id           NUMERIC(38) NOT NULL,
                email                VARCHAR(255) NOT NULL,
                nome                 VARCHAR(255) NOT NULL,
                telefone1            VARCHAR(20),
                telefone2            VARCHAR(20),
                telefone3            VARCHAR(20),
                
                --Chave primária da tabela clientes--
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id),
                
                --Restrição de checagam para garantir que o email inserido seja válido.--
                
                CONSTRAINT check_email_valido CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
              
);

--Comentários da tabela clientes e de suas colunas--

COMMENT ON TABLE lojas.clientes             IS 'Tabela que possue os dados cadastrais dos clientes da loja';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Chave primaria da tabela clientes';
COMMENT ON COLUMN lojas.clientes.email      IS 'Endereco de email dos clientes';
COMMENT ON COLUMN lojas.clientes.nome       IS 'Nome dos clientes segundo documento de identificacao.';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'Telefone principal do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Telefone secudario, caso o cliente tenha.';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'Telefone terciario, caso o cliente tenha.';

--Criando a tabela envios juntamente com suas colunas--

CREATE TABLE lojas.envios (
                envio_id          NUMERIC(38) NOT NULL,
                loja_id           NUMERIC(38) NOT NULL,
                cliente_id        NUMERIC(38) NOT NULL,
                endereco_entrega  VARCHAR(512) NOT NULL,
                status            VARCHAR(15) NOT NULL,
                
                --Chave primária da tabela envios--
                CONSTRAINT pk_envios PRIMARY KEY (envio_id),
                
                --Restrição de checagam para garantir que os status do produtos enviados sejam apenas esses já pré - estabelecidos--
                
                CONSTRAINT check_status CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'))
               
);

--Comentários da tabela envios e de suas colunas--

COMMENT ON TABLE lojas.envios                    IS 'Tabela que registra os dados de envio dos pedidos de cada cliente.';
COMMENT ON COLUMN lojas.envios.envio_id          IS 'Chave primaria da tabela, registra o numero de envio do pedido.';
COMMENT ON COLUMN lojas.envios.loja_id           IS 'Chave estrangeira para identificar de quais das lojas o pedido vai ser enviado.';
COMMENT ON COLUMN lojas.envios.cliente_id        IS 'Chave estrangeira para identificar o cliente para qual o produto deve ser enviado.';
COMMENT ON COLUMN lojas.envios.endereco_entrega  IS 'Coluna para armazenar o endereco de entrega de cada envio a ser feito.';
COMMENT ON COLUMN lojas.envios.status            IS 'Status do envio do pedido para o cliente.';

--Criando a tabela pedidos juntamente com suas colunas--

CREATE TABLE lojas.pedidos (
                pedido_id         NUMERIC(38) NOT NULL,
                data_hora         TIMESTAMP NOT NULL,
                cliente_id        NUMERIC(38) NOT NULL,
                status            VARCHAR(15) NOT NULL,
                loja_id           NUMERIC(38) NOT NULL,
                
                --Chave primária da tabela pedidos--
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id),
                
                --Restrição de checagam para garantir que os status dos produtos enviados sejam apenas esses já pré - estabelecidos--
                CONSTRAINT check_status CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'))
                
);

--Comentários da tabela pedidos e de suas colunas--

COMMENT ON TABLE lojas.pedidos             IS 'Tabela para registrar todos os pedidos feitos e dados relacionados.';
COMMENT ON COLUMN lojas.pedidos.pedido_id  IS 'Chave primaria da tabela, registra o numero do pedido';
COMMENT ON COLUMN lojas.pedidos.data_hora  IS 'Dados de data e hora para identificar o exato momento do pedido';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Chave estrageira (FK) que faz relacao com a tabela clientes, afim de identificar os dados do cliente que fez o pedido';
COMMENT ON COLUMN lojas.pedidos.status     IS 'Coluna para verificar o andamento do pedido, ou seja, status';
COMMENT ON COLUMN lojas.pedidos.loja_id    IS 'Chave estrangeira para identificar para quais das lojas o pedido foi feito.';


--Criando a tabela pedidos_itens juntamente com suas colunas--

CREATE TABLE lojas.pedidos_itens (
                pedido_id        NUMERIC(38) NOT NULL,
                produto_id       NUMERIC(38) NOT NULL,
                numero_da_linha  NUMERIC(38) NOT NULL,
                preco_unitario   NUMERIC(10,2) NOT NULL,
                quantidade       NUMERIC(38) NOT NULL,
                envio_id         NUMERIC(38) NOT NULL,
                
                --Chave primária da tabela pedidos_itens--
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id),
                
                --Restrição de checagam para garantir que as quantidades não sejam negativas--
                CONSTRAINT check_quantidade_nao_negativa CHECK (quantidade >= 0),
                
                --Restrição de checagam para garantir que o preço não seja negativo--
                CONSTRAINT check_preco_unitario_nao_negativo CHECK (preco_unitario >= 0)
);

--Comentários da tabela pedidos_itens e de suas colunas--

COMMENT ON TABLE lojas.pedidos_itens                   IS 'Tabela para registrar os itens de cada pedido feito.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id        IS 'Chave estrangeira primaria que faz relacao com a tabela pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id       IS 'Chave estrangeira primaria que faz relacao com a tabela produtos.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha  IS 'Numero da linha onde consta o item.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario   IS 'Preco unitario de cada item.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade       IS 'Quantidade de itens por pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id         IS 'Chave estrageira que faz relacao com a tabela envios.';

--Fim do segundo segmento--


/*  
Início do terceiro segmento

Nesse bloco todos os relacionamentos existentes entre as tabelas serão criados.
*/

-- Criando um relacionamento não identificado entre as tabelas estoques e produtos através da chave estrangeira (FK) produto_id--

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento identificado entre as tabelas pedidos_itens e produtos através da chave primária estrangeira (PFK) produto_id--

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento não identificado entre as tabelas pedidos e lojas através da chave estrangeira (FK) loja_id--

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento não identificado entre as tabelas envios e lojas através da chave estrangeira (FK) loja_id--

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento não identificado entre as tabelas estoques e lojas através da chave estrangeira (FK) loja_id--

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento não identificado entre as tabelas pedidos e clientes através da chave estrangeira (FK) cliente_id--

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento não identificado entre as tabelas envios e clientes através da chave estrangeira (FK) cliente_id--

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento não identificado entre as tabelas pedidos_itens e envios através da chave estrangeira (FK) envio_id--

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Criando um relacionamento identificado entre as tabelas pedidos_itens e pedidos através da chave primária estrangeira (PFK) pedido_id--

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Fim do terceiro segmento--