show databases;
-- Criando a tabela
 create database football;
 use football;
 
 -- Tabela de Times
CREATE TABLE team (
    idTeam INT AUTO_INCREMENT PRIMARY KEY,
    teamName VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    foundedYear INT
);

-- Tabela de Jogadores
CREATE TABLE player (
    idPlayer INT AUTO_INCREMENT PRIMARY KEY,
    playerName VARCHAR(100) NOT NULL,
    birthDate DATE,
    position ENUM('Goleiro', 'Zagueiro', 'Lateral', 'Meio-campo', 'Atacante') NOT NULL,
    idTeam INT,
    FOREIGN KEY (idTeam) REFERENCES team(idTeam)
);

-- Tabela de Campeonatos
CREATE TABLE championship (
    idChampionship INT AUTO_INCREMENT PRIMARY KEY,
    champName VARCHAR(100) NOT NULL,
    year YEAR NOT NULL
);


-- Tabela de Partidas
CREATE TABLE matchs (
    idMatch INT AUTO_INCREMENT PRIMARY KEY,
    idChampionship INT,
    dateMatch DATE NOT NULL,
    idHomeTeam INT,
    idAwayTeam INT,
    homeScore INT DEFAULT 0,
    awayScore INT DEFAULT 0,
    FOREIGN KEY (idChampionship) REFERENCES championship(idChampionship),
    FOREIGN KEY (idHomeTeam) REFERENCES team(idTeam),
    FOREIGN KEY (idAwayTeam) REFERENCES team(idTeam)
);

-- Estatísticas de Jogadores em cada partida
CREATE TABLE playerStats (
    idPlayer INT,
    idMatch INT,
    goals INT DEFAULT 0,
    assists INT DEFAULT 0,
    yellowCards INT DEFAULT 0,
    redCards INT DEFAULT 0,
    PRIMARY KEY (idPlayer, idMatch),
    FOREIGN KEY (idPlayer) REFERENCES player(idPlayer),
    FOREIGN KEY (idMatch) REFERENCES matchs(idMatch)
);

-- colocando dados na tabela

-- Inserir times
INSERT INTO team (teamName, city, foundedYear) VALUES
('Flamengo', 'Rio de Janeiro', 1895),
('Palmeiras', 'São Paulo', 1914),
('Grêmio', 'Porto Alegre', 1903);

-- Inserir jogadores
INSERT INTO player (playerName, birthDate, position, idTeam) VALUES
('Gabriel Barbosa', '1996-08-30', 'Atacante', 1),
('Weverton', '1987-02-13', 'Goleiro', 2),
('Diego Souza', '1985-06-22', 'Meio-campo', 3);

-- Inserir campeonatos
INSERT INTO championship (champName, year) VALUES
('Brasileirão Série A', 2025),
('Copa do Brasil', 2025);

-- Inserir partidas
INSERT INTO matchs (idChampionship, dateMatch, idHomeTeam, idAwayTeam, homeScore, awayScore) VALUES
(1, '2025-06-10', 1, 2, 2, 1),
(1, '2025-06-15', 3, 1, 0, 3);

-- Inserir estatísticas dos jogadores nas partidas
INSERT INTO playerStats (idPlayer, idMatch, goals, assists, yellowCards, redCards) VALUES
(1, 1, 2, 1, 0, 0),
(2, 1, 0, 0, 1, 0),
(3, 2, 0, 0, 0, 0),
(1, 2, 1, 0, 0, 0);

-- Recuperações simples com SELECT Statement;

Mostrar todos os times
SELECT * FROM team;

Listar todos os jogadores com o nome do time que jogam
SELECT p.playerName, p.position, t.teamName
FROM player p
LEFT JOIN team t ON p.idTeam = t.idTeam;

-- Filtros com WHERE Statement;


Jogadores que atuam na posição "Atacante"
SELECT playerName, position 
FROM player
WHERE position = 'Atacante';


Times fundados antes de 1910
SELECT teamName, foundedYear
FROM team
WHERE foundedYear < 1910;

-- Criando expressões para gerar atributos derivados;

Calcular a idade atual dos jogadores a partir da data de nascimento (birthDate)
SELECT playerName, birthDate,
       YEAR(CURDATE()) - YEAR(birthDate) AS idade
FROM player;


Mostrar o total de gols + assistências de cada jogador em todas as partidas
SELECT p.playerName,
       SUM(ps.goals) AS totalGols,
       SUM(ps.assists) AS totalAssistencias,
       SUM(ps.goals + ps.assists) AS totalParticipacoes
FROM playerStats ps
JOIN player p ON ps.idPlayer = p.idPlayer
GROUP BY p.playerName;

-- Definindo ordenações dos dados com ORDER BY;


Listar jogadores ordenados por nome (ordem alfabética)
SELECT playerName, position
FROM player
ORDER BY playerName ASC;SELECT playerName, position
FROM player
ORDER BY playerName ASC;

Listar jogadores ordenados da data de nascimento mais recente para a mais antiga (mais jovem para mais velho)
SELECT playerName, birthDate
FROM player
ORDER BY birthDate DESC;


-- Condições de filtros aos grupos – HAVING Statement;

Mostrar jogadores que fizeram mais de 1 gol no total das partidas
SELECT p.playerName, SUM(ps.goals) AS totalGols
FROM playerStats ps
JOIN player p ON ps.idPlayer = p.idPlayer
GROUP BY p.playerName
HAVING SUM(ps.goals) > 1;

Mostrar times que marcaram mais de 2 gols como mandante
SELECT t.teamName, SUM(m.homeScore) AS totalGolsMandante
FROM matchs m
JOIN team t ON m.idHomeTeam = t.idTeam
GROUP BY t.teamName
HAVING SUM(m.homeScore) > 2;


-- Criando junções entre tabelas para fornecer uma perspectiva mais complexa dos dados;

Listar os jogadores com nome do time em que jogam
SELECT 
    p.playerName,
    p.position,
    t.teamName
FROM player p
JOIN team t ON p.idTeam = t.idTeam;

Mostrar estatísticas de cada jogador por partida, com nome do jogador e data do jogo
SELECT 
    pl.playerName,
    m.dateMatch,
    ps.goals,
    ps.assists,
    ps.yellowCards,
    ps.redCards
FROM playerStats ps
JOIN player pl ON ps.idPlayer = pl.idPlayer
JOIN matchs m ON ps.idMatch = m.idMatchs


