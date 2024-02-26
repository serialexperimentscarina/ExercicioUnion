CREATE DATABASE faculdade
GO
USE faculdade
GO
CREATE TABLE curso (
codigo_curso		INT				NOT NULL,
nome				VARCHAR(70)		NOT NULL,
sigla				VARCHAR(10)		NOT NULL
PRIMARY KEY (codigo_curso)
)
GO
CREATE TABLE palestrante (
codigo_palestrante	INT				IDENTITY,
nome				VARCHAR(250)	NOT NULL,
empresa				VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo_palestrante)
)
GO
CREATE TABLE aluno (
ra					CHAR(7)			NOT NULL,
nome				VARCHAR(250)	NOT NULL,
codigo_curso		INT				NOT NULL
PRIMARY KEY (ra)
FOREIGN KEY (codigo_curso) REFERENCES curso (codigo_curso)
)
GO
CREATE TABLE palestra (
codigo_palestra		INT				IDENTITY,
titulo				VARCHAR(MAX)	NOT NULL,
carga_horaria		INT				NOT NULL,
data				DATETIME		NOT NULL,
codigo_palestrante	INT				NOT NULL
PRIMARY KEY (codigo_palestra)
FOREIGN KEY (codigo_palestrante) REFERENCES palestrante (codigo_palestrante)
)
GO
CREATE TABLE alunos_inscritos (
ra					CHAR(7)			NOT NULL,
codigo_palestra		INT				NOT NULL
PRIMARY KEY (ra, codigo_palestra),
FOREIGN KEY (ra) REFERENCES aluno (ra),
FOREIGN KEY (codigo_palestra) REFERENCES palestra(codigo_palestra)
)
GO
CREATE TABLE nao_alunos (
rg					VARCHAR(9)		NOT NULL,
orgao_exp			CHAR(5)			NOT NULL,
nome				VARCHAR(250)	NOT NULL
PRIMARY KEY (rg, orgao_exp)
)
GO
CREATE TABLE nao_alunos_inscritos (
codigo_palestra		INT				NOT NULL,
rg					VARCHAR(9)		NOT NULL,
orgao_exp			CHAR(5)			NOT NULL
PRIMARY KEY (codigo_palestra, rg, orgao_exp),
FOREIGN KEY (codigo_palestra) REFERENCES palestra (codigo_palestra),
FOREIGN KEY (rg, orgao_exp) REFERENCES nao_alunos (rg, orgao_exp)
)

INSERT INTO curso VALUES (
1, 'Análise e Desenvolvimento de Sistemas', 'ADS'
)

INSERT INTO aluno VALUES 
('0000001', 'Lain Iwakura', 1),
('0000002', 'Alice Mizuki', 1),
('0000003', 'Kanade Yoisaki', 1),
('0000004', 'Mafuyu Asahina', 1),
('0000005', 'Ena Shinonome', 1),
('0000006', 'Mizuki Akiyama', 1)

INSERT INTO palestrante VALUES
('Saya', 'Saya no Uta')

INSERT INTO palestra VALUES
('Denpa', 100, GETDATE(), 1)

INSERT INTO alunos_inscritos VALUES
('0000001',  1),
('0000002',  1),
('0000003', 1),
('0000004', 1),
('0000005', 1),
('0000006', 1)

INSERT INTO nao_alunos VALUES
('111111111', 'SSPSP', 'Miku Hatsune'),
('222222222', 'SSPSP', 'Rin Kagamine'),
('333333333', 'SSPSP', 'Len Kagamine'),
('444444444', 'SSPSP', 'Luka Megurine')

INSERT INTO nao_alunos_inscritos VALUES
(1,	'111111111', 'SSPSP'),
(1, '222222222', 'SSPSP'),
(1, '333333333', 'SSPSP'),
(1, '444444444', 'SSPSP')

CREATE VIEW lista_de_presenca
AS
SELECT a.ra AS num_documento, a.nome AS nome, p.titulo AS titulo_palestra, pt.nome AS nome_palestrante, p.carga_horaria AS carga_horaria, p.data AS data
FROM aluno a, palestra p, alunos_inscritos ai, palestrante pt
WHERE a.ra = ai.ra AND ai.codigo_palestra = p.codigo_palestra AND pt.codigo_palestrante = p.codigo_palestrante
UNION
SELECT CONCAT(na.rg,' ', na.orgao_exp) AS num_documento, na.nome AS nome, p.titulo AS titulo_palestra, pt.nome AS nome_palestrante, p.carga_horaria AS carga_horaria, p.data AS data
FROM nao_alunos na, palestra p, nao_alunos_inscritos nai, palestrante pt
WHERE na.orgao_exp = nai.orgao_exp AND na.rg = nai.rg AND nai.codigo_palestra = p.codigo_palestra AND pt.codigo_palestrante = p.codigo_palestrante

SELECT * FROM lista_de_presenca