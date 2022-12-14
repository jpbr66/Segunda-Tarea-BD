USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_editarPersona]    Script Date: 19/10/2022 00:10:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_editarPersona]
	@inId INT,
	@inNombre VARCHAR(128),	 
	@inValorDocId BIGINT,
	@inTipoDoc VARCHAR(128),
	@inEmail VARCHAR(128),
	@inTele1 BIGINT,
	@inTele2 BIGINT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResult=0;
		DECLARE @idTipoDoc INT;
		SELECT @idTipoDoc = T.ID
		FROM dbo.TipoDocIdent T
		WHERE T.Nombre = @inTipoDoc;
		BEGIN TRANSACTION tEditarPersona
			UPDATE [dbo].[Persona]
			SET Nombre = @inNombre,
			ValorDocId =  @inValorDocId,
			IdTipoDoc = @idTipoDoc,
			email  = @inEmail,
			telefono1 = @inTele1,
			telefono2 = @inTele2
			WHERE ID = @inId
		COMMIT TRANSACTION tEditarPersona
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tEditarPersona;
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
			--ERROR_STATE(),
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

