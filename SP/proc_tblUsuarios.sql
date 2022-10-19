USE [SegundaTarea]
GO
/****** Object:  StoredProcedure [dbo].[proc_tblUsuarios]    Script Date: 19/10/2022 00:23:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[proc_tblUsuarios]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT U.ID, U.UserName, U.[Password], U.TipoUsuario, P.Nombre
	FROM dbo.Usuario U
	INNER JOIN dbo.Persona P
	ON P.ID = U.IdPersona
END
