// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
   $("#part_start_date").datepicker({dateFormat: 'yy-mm-dd'});
   $("#part_finish_date").datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
	$("#part_start_date_s").datepicker({dateFormat: 'yy-mm-dd'});
    $("#part_end_date_s").datepicker({dateFormat: 'yy-mm-dd'});
});

//for calculating total
$(function(){
    $("#part_qty").change(function(){
    	$("#part_total").val(SumTotal());
    });
});
$(function(){
    $("#part_unit_price").change(function(){
    	$("#part_total").val(SumTotal());
    });
});
$(function(){
    $("#part_shipping_cost").change(function(){
    	$("#part_total").val(SumTotal());
    });
});
$(function(){
    $("#part_tax").change(function(){
    	$("#part_total").val(SumTotal());
    });
});
$(function(){
    $("#part_misc_cost").change(function(){
    	$("#part_total").val(SumTotal());
    });
});

function SumTotal() {
	var rpt = ($("#part_qty").val() * $("#part_unit_price").val());
	var total = 0.0000;
	if ($.isNumeric(rpt)) {
		total += rpt;
	};
	if ($.isNumeric($('#part_shipping_cost').val())) {
		total += parseFloat($('#part_shipping_cost').val());
	};
	if ($.isNumeric($('#part_tax').val())) {
		total += parseFloat($('#part_tax').val());
	};
	if ($.isNumeric($('#part_misc_cost').val())) {
		total += parseFloat($('#part_misc_cost').val());
	};
	if ($.isNumeric(total)) {
		return total.toFixed(2);
	};
	return; 
};
