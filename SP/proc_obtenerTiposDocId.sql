USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_obtenerTiposDocId]    Script Date: 19/10/2022 00:18:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_obtenerTiposDocId]
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT t.Nombre
	FROM dbo.TipoDocIdent t
	ORDER BY Nombre
	SET NOCOUNT OFF;
END;

