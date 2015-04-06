var get_currency_rate = function(current_curr, parent_type) {
  var process_rate = 1.00000;
  $.ajax({
    type: "GET",
    url: "/find_rate",
    dataType: "JSON",
    data: current_curr,
    success: function(data) {
      if (data != null) {
        process_rate = data['selling'];
        if (parent_type == "invoice") {
          $(".invoice-curr-rate").val(process_rate);
        }
        $("#parent-curr-rate-div").show();
      } else {
        toastr.error("Bu tarihte döviz kurları bulunamadı/Currency rates not avaliable at this date");
      }
    }
  });
};

var change_invoice_rate = function(event, asset_name) {
  var currency_rate;
  if ($(".invoice-curr").first().find('option:selected').val() !== $(".invoice-local-curr").val()) {
    currency_rate = {
      curr: $(".invoice-curr").val(),
      rate_date: $(".invoice-date").val()
    };
    get_currency_rate(currency_rate, "invoice");
  } else {
    $("#parent-curr-rate-div").hide();
    return $(".invoice-curr-rate").val(1.00000);
  }
};
$(document).on("change", ".invoice-curr", function(event) {
  return change_invoice_rate(event);
});
$(document).on("change", ".invoice-date", function(event) {
  return change_invoice_rate(event);
});
