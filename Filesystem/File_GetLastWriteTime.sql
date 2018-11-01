USE [CodeLib]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* 
	--Example:
	DECLARE @LastWriteTime DATETIME;
	EXEC File_GetLastWriteTime 
		@LastWriteTime = @LastWriteTime OUTPUT,
		@FilePath = 'C:\Temp\Neues Textdokument.txt';
	SELECT @LastWriteTime AS LastWriteTime;
*/

CREATE PROCEDURE [dbo].[File_GetLastWriteTime]
	@LastWriteTime DATETIME OUTPUT,
	@FilePath VARCHAR(512)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @psCommand AS varchar(1024) = '';

	EXEC xp_sprintf @psCommand OUTPUT, 
		'powershell.exe -command if(Test-Path -Path ''%s'') { (Get-Item ''%s'').LastWriteTime.ToString(''dd.MM.yyyy'') } ', 
		@filePath, @filePath

	DECLARE @cmdResults TABLE (
		[output] varchar(1024)
	)

	INSERT INTO @cmdResults
	EXEC xp_cmdshell @psCommand

	SELECT @LastWriteTime = CONVERT(DATETIME, [output], 104)
		FROM @cmdResults 
		WHERE [output] IS NOT NULL

END
