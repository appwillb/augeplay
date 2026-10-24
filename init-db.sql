-- ==========================================================
-- PLAYAUGE / GPSMUSIC — Schema de Banco de Dados PostgreSQL
-- ==========================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Usuários e Perfis Profissionais
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'musico', -- musico, artista, produtor, banda
    avatar_url TEXT,
    bio TEXT,
    city VARCHAR(100),
    state VARCHAR(10),
    phone VARCHAR(30),
    is_available BOOLEAN DEFAULT TRUE,
    base_rate NUMERIC(10, 2), -- Cachê base sugerido (R$)
    service_radius_km INT DEFAULT 100,
    rating NUMERIC(3, 2) DEFAULT 5.0,
    ratings_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Vídeos dos Músicos (Solos, Ensaios, Gigs)
CREATE TABLE IF NOT EXISTS musician_videos (
    id VARCHAR(64) PRIMARY KEY,
    musician_id VARCHAR(64) REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    instrument VARCHAR(100) NOT NULL,
    video_url TEXT NOT NULL,
    thumbnail_url TEXT,
    duration_seconds INT NOT NULL DEFAULT 60,
    views_count INT DEFAULT 0,
    likes_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Músicas e Composições Autorais
CREATE TABLE IF NOT EXISTS songs (
    id VARCHAR(64) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist_id VARCHAR(64) REFERENCES users(id) ON DELETE CASCADE,
    composer_name VARCHAR(255),
    genre VARCHAR(100) NOT NULL,
    audio_url TEXT NOT NULL,
    musical_key VARCHAR(20),
    bpm INT,
    lyrics TEXT,
    is_for_sale BOOLEAN DEFAULT FALSE,
    plays_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Convites de Trabalho e Contratos de Cachê
CREATE TABLE IF NOT EXISTS gig_contracts (
    id VARCHAR(64) PRIMARY KEY,
    contractor_id VARCHAR(64) REFERENCES users(id) ON DELETE CASCADE,
    musician_id VARCHAR(64) REFERENCES users(id) ON DELETE CASCADE,
    event_date DATE NOT NULL,
    event_location VARCHAR(255) NOT NULL,
    cache_agreed NUMERIC(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pendente', -- pendente, aceito, negociando, recusado, concluido
    negotiation_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Mensagens do Chat em Tempo Real
CREATE TABLE IF NOT EXISTS chat_messages (
    id VARCHAR(64) PRIMARY KEY,
    sender_id VARCHAR(64) REFERENCES users(id) ON DELETE CASCADE,
    receiver_id VARCHAR(64) REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text', -- text, audio, video_call_invite, contract
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
