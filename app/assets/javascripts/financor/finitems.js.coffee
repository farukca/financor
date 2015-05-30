jQuery ->
  set_sales_view = ->
    if $('#finitem_salable').is(":checked")
      $('#sales_details').show()
    else
      $('#sales_details').hide()

  set_purchase_view = ->
    if $('#finitem_purchasable').is(":checked")
      $('#purchase_details').show()
    else
      $('#purchase_details').hide()

  set_stock_view = ->
    if $('#finitem_stockable').is(":checked")
      $('#stock_details').show()
    else
      $('#stock_details').hide()

  $(document).on "change", "#finitem_salable", (event) ->
    set_sales_view()

  $(document).on "change", "#finitem_purchasable", (event) ->
    set_purchase_view()

  $(document).on "change", "#finitem_stockable", (event) ->
    set_stock_view()
    
  set_sales_view()
  set_purchase_view()
  set_stock_view()