CREATE DATABASE atividade14_03
GO
USE atividade14_03
GO
 
CREATE TABLE Produto(
Codigo	INT NOT NULL,
Nome	VARCHAR(100),
Valor	DECIMAL(7,2),
PRIMARY KEY(Codigo))
GO

CREATE TABLE Entrada(
Codigo_Transacao	INT NOT NULL,
Codigo_Produto		INT NOT NULL,
Quantidade 			INT,
Valor_Total			DECIMAL(7,2)
PRIMARY KEY(Codigo_Transacao, Codigo_Produto)
FOREIGN KEY (Codigo_Produto) REFERENCES produto(Codigo)
)
GO

CREATE TABLE Saida(
Codigo_Transacao	INT NOT NULL,
Codigo_Produto		INT NOT NULL,
Quantidade 			INT,
Valor_Total			DECIMAL(7,2)
PRIMARY KEY(Codigo_Transacao, Codigo_Produto)
FOREIGN KEY (Codigo_Produto) REFERENCES produto(Codigo)
)
GO
 
INSERT INTO Produto VALUES 
(1,	'tenis',		40.00),	
(2,	'camisa',		30.00),
(3,	'chocolate',	8.00),	
(4,	'computador',	3000.00),
(5,	'pão',			1.00),
(6,	'carteira',		25.00)

SELECT * FROM Produto
SELECT * FROM Entrada
SELECT * FROM Saida

DELETE Entrada
DELETE Saida

DROP PROCEDURE sp_entrada_ou_saida_produto

CREATE PROCEDURE sp_entrada_ou_saida_produto(@escolha VARCHAR(2), @transacao INT, 
	@codigo_produto INT, @quantidade INT , @saida VARCHAR(30) OUTPUT)
AS
	DECLARE @tam		INT,
			@tabela 	VARCHAR(10),
			@erro		VARCHAR(MAX),
			@query		VARCHAR(MAX)

	IF(UPPER(@escolha) = 'E')
	BEGIN
		SET @tabela = 'Entrada'
	END
	ELSE IF (UPPER(@escolha) = 'S')
	BEGIN
		SET @tabela = 'Saida'
	END

	DECLARE @valor_total DECIMAL(7,2)
	DECLARE @valor DECIMAL(7,2)

	SELECT @valor = Produto.Valor FROM Produto WHERE Produto.Codigo = @codigo_produto
	SET @valor_total = @valor * @quantidade

	SET @query = 'INSERT INTO '+@tabela+' VALUES ('+CAST(@transacao AS VARCHAR(5))+','+CAST(@codigo_produto AS VARCHAR(5))+ 
		', '+CAST(@quantidade AS VARCHAR(5))+','+CAST(@valor_total AS VARCHAR(15))+')'

	PRINT @query
	BEGIN TRY
		EXEC (@query)
		IF(UPPER(@escolha) = 'E')
		BEGIN
			SET @saida = 'Entrada inserida com sucesso'
		END
		ELSE IF (UPPER(@escolha) = 'S')
		BEGIN
			SET @saida = 'Saida inserida com sucesso'
		END
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('Id duplicado', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro no armazenamento do produto', 16, 1)
		END
	END CATCH

DECLARE @out1 VARCHAR(30)
EXEC sp_entrada_ou_saida_produto 'e', 1001, 1, 4, @out1 OUTPUT
PRINT @out1
 
DECLARE @out2 VARCHAR(30)
EXEC sp_entrada_ou_saida_produto 's', 2001, 4, 8, @out2 OUTPUT
PRINT @out2
