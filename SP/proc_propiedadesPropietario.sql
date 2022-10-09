USE [PrimerTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_filtrarNombre]    Script Date: 6/9/2022 19:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[proc_filtrarNombre](
	@Nombre VARCHAR(32)
	) AS
BEGIN
	DECLARE @Articulo TABLE(
			Nombre VARCHAR(32),
			ClaseArticulo VARCHAR(32),
			Precio MONEY
	)
	SET NOCOUNT ON;

	IF ISNULL(@Nombre,'')=''
		BEGIN
			SELECT A.Nombre, C.Nombre, A.Precio
			FROM dbo.Articulo A
			INNER JOIN dbo.ClaseArticulo C
			ON A.idClaseArticulo = C.id
			ORDER BY A.Nombre
			RETURN;
		END;


	IF EXISTS(
	SELECT 1
	FROM dbo.Articulo A
	WHERE CHARINDEX(@Nombre, A.Nombre)!=0)
		BEGIN
				SELECT A.Nombre, C.Nombre as ClaseArticulo, A.Precio
				FROM dbo.Articulo A 
				INNER JOIN dbo.ClaseArticulo C
				ON A.idClaseArticulo = C.id
				WHERE CHARINDEX(@Nombre, A.Nombre)!=0
				ORDER BY A.Nombre

				RETURN;
		END;

END;



--SELECT * FROM Articulo
--EXEC proc_filtrarNombre 'llo'
