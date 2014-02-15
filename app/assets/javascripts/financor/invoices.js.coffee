# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

calculate_involine_total = ->
  $invoice_total   = 0
  $invoice_balance = 0
  $tax_total       = 0

  $(".invoice-line").each ->
    $qnt_col = $(this).find(".involine-unit-number")
    $price_col = $(this).find(".involine-unit-price")
    $tax_col = $(this).find(".involine-vat-code")
    $total_col = $(this).find(".involine-total")
    
    #console.log($qnt + " | " + $price);
    total = parseFloat($price_col.val()) * parseFloat($qnt_col.val())
    tax_rate = 0
    if $tax_col.children("option:selected").data("rate")
      tax_rate = $tax_col.children("option:selected").data("rate")
      if tax_rate == ""
        tax_rate=0
    tax = (total * tax_rate) / 100
    $total_col.val total
    $invoice_total += total
    $tax_total += tax
    $invoice_balance += (total + tax)

  $("#invoice-total-cell").text $invoice_total
  $("#invoice-tax-cell").text $tax_total
  $("#invoice-balance-cell").text $invoice_balance

$(document).on "change", ".changes-invoice-total", (event) ->
  calculate_involine_total()
