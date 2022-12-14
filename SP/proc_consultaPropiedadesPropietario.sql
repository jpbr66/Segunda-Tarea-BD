USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_consultaPropiedadesPropietario]    Script Date: 19/10/2022 00:00:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_consultaPropiedadesPropietario](
	@inNombre VARCHAR(32),
	@inIdent BIGINT,
	@outResult INT OUTPUT
	) AS
BEGIN
	IF @inNombre != ''
	(
		SELECT P.ID, P.NumFinca, P.ValorFiscal, P.Area, P.FechaRegistro, TZ.Nombre, TT.Nombre
		FROM dbo.Propiedad P
		INNER JOIN dbo.TipoZona TZ
		ON TZ.ID = P.IdTipoZona
		INNER JOIN dbo.TipoTerreno TT
		ON TT.ID = P.IdTipoTerreno
		WHERE P.IdUsuario = 
		(
		  SELECT U.ID
		  FROM dbo.Usuario U
		  WHERE U.TipoUsuario = 'Propietario'
		  AND @inNombre =
		  (
			SELECT Pe.Nombre
			FROM Persona Pe
			WHERE U.IdPersona = Pe.ID
		  )
		)
	)
	ELSE
	(
		SELECT P.ID, P.ValorFiscal, P.Area, P.FechaRegistro, TZ.Nombre, TT.Nombre
		FROM dbo.Propiedad P
		INNER JOIN dbo.TipoZona TZ
		ON TZ.ID = P.IdTipoZona
		INNER JOIN dbo.TipoTerreno TT
		ON TT.ID = P.IdTipoTerreno
		WHERE P.IdUsuario =
		(
		  SELECT U.ID
		  FROM dbo.Usuario U
		  WHERE U.TipoUsuario = 'Propietario'
		  AND @inIdent =
		  (
			SELECT Pe.ValorDocId
			FROM Persona Pe
			WHERE U.IdPersona = Pe.ID
		  )
		)
	)


END;


