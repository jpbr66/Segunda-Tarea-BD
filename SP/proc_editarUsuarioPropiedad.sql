USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_editarUsuarioPropiedad]    Script Date: 19/10/2022 00:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_editarUsuarioPropiedad] 
	@inId INT,
	@inValorDocId BIGINT,
	@inNumFinca INT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		DECLARE @idUsuario INT, @idPropiedad INT;
		
		IF EXISTS (
		SELECT 1 FROM dbo.Usuario U
		INNER JOIN dbo.Persona P
		ON P.ValorDocId = @inValorDocId
		WHERE U.IdPersona = P.ID
		)
			BEGIN
				SELECT @idUsuario = U.ID
				FROM dbo.Usuario U
				INNER JOIN dbo.Persona P
				ON P.ValorDocId = @inValorDocId
				WHERE U.IdPersona = P.ID;

				IF EXISTS (SELECT 1 FROM dbo.Propiedad Pr WHERE Pr.NumFinca = @inNumFinca)
					BEGIN
						SELECT @idPropiedad = Pr.ID
						FROM dbo.Propiedad Pr
						WHERE Pr.NumFinca = @inNumFinca
				
						IF (SELECT Pr.IdUsuario FROM dbo.Propiedad Pr WHERE Pr.NumFinca = @inNumFinca) IS NULL
						OR (SELECT Pr.ID FROM dbo.Propiedad Pr WHERE Pr.NumFinca = @inNumFinca) = @inId
							BEGIN
								BEGIN TRANSACTION tEditarUsuarioPropiedad
									UPDATE [dbo].[Propiedad]
									SET IdUsuario = NULL
									WHERE ID = @inId

									UPDATE [dbo].[Propiedad]
									SET IdUsuario = @idUsuario
									WHERE NumFinca = @inNumFinca
								COMMIT TRANSACTION tEditarUsuarioPropiedad
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
			ROLLBACK TRANSACTION tEditarUsuarioPropiedad;
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

