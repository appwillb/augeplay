# 🚀 Guia de Deploy no Coolify com Banco de Dados Automático

O projeto PlayAuge (GPSMusic) agora está configurado para **subir a aplicação E o banco de dados PostgreSQL automaticamente** no Coolify!

---

## 📦 Como funciona a instalação automática do banco?

Utilizamos o arquivo [`docker-compose.yml`](file:///c:/Users/mauri/OneDrive/Desktop/playauge/docker-compose.yml) que orquestra 2 serviços juntos:

1. **`playauge-web`**:
   - Container Nginx servindo o Flutter Web otimizado.
   - Aguarda o banco ficar saudável (`healthy`) antes de iniciar.
2. **`postgres` (Banco de Dados PostgreSQL Automático)**:
   - Imagem leve oficial `postgres:15-alpine`.
   - **Criação Automática das Tabelas**: O script [`init-db.sql`](file:///c:/Users/mauri/OneDrive/Desktop/playauge/init-db.sql) é executado no primeiro boot, criando:
     - `users` (músicos, perfis, cachês e disponibilidade);
     - `musician_videos` (gravações de solos, ensaios e apresentações);
     - `songs` (músicas autorais, letras e BPM);
     - `gig_contracts` (contratos de cachê negociados nas vídeo chamadas);
     - `chat_messages` (mensagens e histórico).
   - **Persistência de Dados**: Volume `postgres_data` garante que nada se perde em reinicializações ou deploys.

---

## 🛠️ Passo a Passo no Painel do Coolify

1. **Suba o código para o GitHub/GitLab:**
   ```bash
   git add .
   git commit -m "PlayAuge + Postgres automático para Coolify"
   git push
   ```

2. **No Coolify:**
   - Clique em **+ New Resource** ➜ **Application**.
   - Escolha o seu repositório Git.
   - Na opção de **Build Pack**, selecione **Docker Compose** (o Coolify lerá diretamente o `docker-compose.yml`).
   - Defina seu domínio no serviço web (ex.: `https://app.seusite.com.br`).
   - Clique em **Deploy**!

O Coolify irá:
- Baixar e subir o PostgreSQL;
- Executar o `init-db.sql` criando todas as tabelas;
- Compilar o Flutter Web e subir o Nginx na porta 80 com SSL gratuito gerado na hora!
