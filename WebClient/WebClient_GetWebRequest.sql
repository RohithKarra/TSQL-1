USE [CodeLib]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Example:
/*
	DECLARE @Uri VARCHAR(255) = 'https://jsonplaceholder.typicode.com/todos/1';
	DECLARE @WebRequestResult VARCHAR(8000) = dbo.WebClient_GetWebRequest(@Uri);
	IF ISJSON(@WebRequestResult) = 1 BEGIN
		SELECT JSON_VALUE(@WebRequestResult, '$.userId') Id,
			   JSON_VALUE(@WebRequestResult, '$.title') title,
			   JSON_VALUE(@WebRequestResult, '$.completed') completed;
	END
*/
CREATE FUNCTION [dbo].[WebClient_GetWebRequest]
(
	@Uri VARCHAR(255)
)
RETURNS VARCHAR(8000)
AS
BEGIN
	DECLARE @result VARCHAR(255) = '';
	
	DECLARE @MSXML2_XMLHTTP AS INT;
	DECLARE @ResponseText AS VARCHAR(8000);
	DECLARE @ResponseStatus INT = 0;

	EXEC sp_OACreate 'MSXML2.XMLHTTP', @MSXML2_XMLHTTP OUT;
	EXEC sp_OAMethod @MSXML2_XMLHTTP, 'open', NULL, 'get', @Uri, 'false';
	EXEC sp_OAMethod @MSXML2_XMLHTTP, 'send';
	EXEC sp_OAMethod @MSXML2_XMLHTTP, 'ResponseText', @ResponseText OUTPUT;
	EXEC sp_OAMethod @MSXML2_XMLHTTP, 'Status', @ResponseStatus OUTPUT;
	EXEC sp_OADestroy @MSXML2_XMLHTTP;
	
	RETURN @ResponseText;

END
