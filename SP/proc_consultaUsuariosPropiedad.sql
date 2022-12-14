USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_consultaUsuariosPropiedad]    Script Date: 19/10/2022 00:05:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_consultaUsuariosPropiedad](
	@inNumFinca INT,
	@outResult INT OUTPUT
	) AS
BEGIN
	SELECT P.ID, P.Nombre, TDI.Nombre, P.ValorDocId, P.email, P.telefono1, P.telefono2
	FROM dbo.Persona P
	INNER JOIN dbo.TipoDocIdent TDI
	ON P.IdTipoDoc = TDI.ID
	INNER JOIN dbo.Propiedad Pr
	ON Pr.NumFinca = @inNumFinca
	INNER JOIN dbo.PXP PP
	ON PP.IdPropiedad = Pr.ID AND PP.IdPersona = P.ID
END;

--EXEC [proc_consultaPropietarioPropiedad]  1033, 0

