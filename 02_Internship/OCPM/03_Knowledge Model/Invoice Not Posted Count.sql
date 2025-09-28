COUNT(
   CASE WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."STATUS" = 'Invoice Not Posted'
        THEN "o_custom_OpenInvoiceDeepdiveManualFile"."ID"
   END
)
