USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_insertarPersonaPropiedad]    Script Date: 19/10/2022 00:16:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_insertarPersonaPropiedad] 
	@inValorDocId BIGINT,
	@inNumFinca INT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		DECLARE @idPersona INT, @idPropiedad INT, @fecha DATE;
		SET @fecha = GETDATE()

		SELECT @idPersona = P.ID, @idPropiedad = Pr.ID
		FROM dbo.Persona P
		INNER JOIN dbo.Propiedad Pr
		ON Pr.NumFinca = @inNumFinca
		WHERE P.ValorDocId = @inValorDocId;
		IF EXISTS (SELECT 1 FROM dbo.Persona P WHERE P.ValorDocId = @inValorDocId)
			BEGIN
				SELECT @idPersona = P.ID
				FROM dbo.Persona P
				WHERE P.ValorDocId = @inValorDocId;

				IF EXISTS (SELECT 1 FROM dbo.Propiedad Pr WHERE Pr.NumFinca = @inNumFinca)
					BEGIN
						SELECT @idPropiedad = Pr.ID
						FROM dbo.Propiedad Pr
						WHERE Pr.NumFinca = @inNumFinca
				
						IF NOT EXISTS (
						SELECT 1 FROM dbo.PXP PP
						WHERE PP.IdPersona = @idPersona
						AND PP.IdPropiedad = @idPropiedad
						AND PP.FechaFin IS NULL)
							BEGIN
								BEGIN TRANSACTION tInsertarPersonaPropiedad
									INSERT INTO [dbo].[PXP] (
									IdPersona
									, IdPropiedad
									, FechaInicio
									, FechaFin
									)
									VALUES (
									@idPersona
									, @idPropiedad
									, @fecha
									, NULL
									)
								COMMIT TRANSACTION tInsertarPersonaPropiedad
							END
						ELSE
							SET @outResult=50010;
					END
				ELSE
					SET @outResult=50009;
			END
		ELSE
			SET @outResult=50008;
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tInsertarPersonaPropiedad;
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

