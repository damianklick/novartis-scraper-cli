//for day-to-day
$('.day-to-day .headline div h5').each(function () {
        if ($(this).text().trim() == 'CancerCare') {
            $(this).html('<h5>Cancer<i>Care</i></h5>');
        }
});
//for list-with-pattern
$('.list-with-pattern .headline div').each(function () {
    if ($(this).text().trim() == 'CancerCare') {
        $(this).html('<h5>Cancer<i>Care</i></h5>');
    }
});
//for foundation headline
$('.foundation-headline').each(function () {
        if ($(this).text().trim() == 'CancerCare') {
            $(this).html('Cancer<i>Care</i>');
        }
});