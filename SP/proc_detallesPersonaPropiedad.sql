USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_detallesPersonaPropiedad]    Script Date: 19/10/2022 00:08:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_detallesPersonaPropiedad]
	@inId INT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		DECLARE @fecha DATE;
		SET @fecha = GETDATE()

		BEGIN TRANSACTION tDetallesPersonaPropiedad
			SELECT P.Nombre, Pr.NumFinca, PP.FechaInicio, PP.FechaFin
			FROM dbo.PXP PP
			INNER JOIN dbo.Persona P
			ON P.ID = PP.IdPersona
			INNER JOIN dbo.Propiedad Pr
			ON Pr.ID = PP.IdPropiedad
			WHERE PP.ID = @inId
		COMMIT TRANSACTION tDetallesPersonaPropiedad
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tDetallesPersonaPropiedad;
		END;
		INSERT INTO dbo.DBErrors(
		 [UserName]
		, [ErrorNumber]
		, [ErrorState]
		, [ErrorSeverity]
		, [ErrorLine]
		, [ErrorProcedure]
		, [ErrorMessage]
		, [ErrorDateTime])
		VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);
		Set @outResult=50007;
	END CATCH
	SET NOCOUNT OFF;
END;

