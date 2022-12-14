USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_propiedadesPropietario]    Script Date: 19/10/2022 04:12:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_propiedadesPropietario](
	@inUser VARCHAR(32),
	@outResult INT OUTPUT
	) AS
BEGIN

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
	  WHERE @inUser = U.UserName
	)


END;



--SELECT * FROM Articulo
--EXEC proc_propiedadesPropietario 'jpbr66', 0
