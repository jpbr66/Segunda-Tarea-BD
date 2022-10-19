USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_consultaMovConsumoPropiedad]    Script Date: 19/10/2022 04:05:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_consultaMovConsumoPropiedad]
	@inId INT,
	@outResult INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResult=0;
		
		BEGIN TRANSACTION tDetallesPersona
			SELECT P.NumFinca, TMC.Nombre, MC.Fecha, MC.Monto, PCA.SaldoAcumulado
			FROM dbo.MovimientoConsumo MC
			INNER JOIN dbo.Propiedad P
			ON P.ID = @inId
			INNER JOIN dbo.PropiedadCCAgua PCA
			ON MC.IdPropiedadCCAgua = PCA.ID
			INNER JOIN dbo.TipoMovimientoConsumo TMC
			ON TMC.ID = MC.IdTipoMovimiento
			INNER JOIN dbo.PropiedadXCC PCC
			ON PCC.IdPropiedad = P.ID
			WHERE PCC.ID = PCA.ID
		COMMIT TRANSACTION tDetallesPersona	
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT> 0
		BEGIN
			ROLLBACK TRANSACTION tDetallesPersona;
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

