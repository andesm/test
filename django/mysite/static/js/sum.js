$(function($){
    django.jQuery(document).ready(function() {
        setInterval(function(){
            let custom = $("#result_list .custom").map(function() { return this.id; }).get();
            console.log(custom);
            if (custom != "") {
                re = /test-(\d+)/;
                for(item of custom) {
                    id = item.match(re);
                    console.log(id[1]);
                    tag = "#result_list #test-" + String(id[1]);
                    let num = $(tag).text();
                    console.log(num);
                    num = parseInt(num) + 1;
                    $(tag).text(String(num));
                }
            } else {
                console.log("none");
            }
        }, 10 * 1000);
    });
})

$(function($){
    django.jQuery('.form-group').keyup(function(){
        let numA = $('#id_quantity').val();
        let numB = $('#id_unit_price').val();
        // 整数に置き換えて変数に渡す
        numA = parseInt(numA);
        numB = parseInt(numB);
        // 乗算された数を渡す
        $('#id_amount_money').val(numA*numB);
    });
});
