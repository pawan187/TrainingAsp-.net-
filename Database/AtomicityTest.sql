USE [BikeStores]
GO
/****** Object:  StoredProcedure [dbo].[ATOMICITYTEST]    Script Date: 20-02-2021 11:06:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ATOMICITYTEST]
	-- Add the parameters for the stored procedure here
	@order_id INT,
	@item_id INT,
	@product_id INT,
	@quantity INT,
	@list_price DECIMAL(10,2),
	@discount DECIMAL(4,2),
	@store_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
    -- Insert statements for procedure here
		BEGIN TRANSACTION
			INSERT INTO SALES.order_items VALUES(@order_id,@item_id,@product_id,@quantity,@list_price,@discount);
			--SELECT 1/0;
			UPDATE PRODUCTION.stocks SET 
			quantity=(SELECT quantity FROM production.stocks WHERE store_id=@store_id AND product_id=@product_id)-@quantity
			WHERE store_id=@store_id AND product_id = @product_id
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		--RAISERROR (15600,-1,-1, 'ORDER_ERROR');  
	END CATCH
END
