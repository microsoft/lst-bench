DELETE FROM store_sales
WHERE SS_ITEM_SK IN (${SS_ITEM_SK}) AND SS_TICKET_NUMBER IN (${SS_TICKET_NUMBER});
