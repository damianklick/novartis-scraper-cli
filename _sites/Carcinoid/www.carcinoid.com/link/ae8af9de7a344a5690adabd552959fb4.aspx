/*
 *  Edit(Author: Hugo): This file is not intended to be loaded in the solution, that's why it's not located in /Scripts. It's
 *  intended to be uploaded in the admin in the "Links to js files" property in the homepage of the brand website
 *  you want to have the Adobe Tracking implemented.
 * 
 *  => Replace the brandName var by the new brand name before uploading the file!
 */


/*
 *  !!!!!   Replace the brandName var by the correct brand Name when uploading this file for a new brand:   !!!!!
 */
var brandName = "Carcinoid";


var dataLayer = dataLayer || {};
// global vars
var path = window.location.pathname.split('/'),
pageName,
channel,
brandProduct,
campaign;

// set pageName var
var hasEndSlash = (window.location.pathname.lastIndexOf('/') == window.location.pathname.length - 1);
if (hasEndSlash) {
    if (path[path.length - 1] == "") {
        path.pop();
    }
}
path = path.slice(1);
pageName = path.join(':').toLowerCase();
pageName = path.length == 0 ? 'patient:products:' + brandName : 'patient:products:' + brandName + ':' + pageName;

var formResult = '',
    formName = '';


// build dataLayer var
dataLayer = {
    page: {
        pageName: pageName,
        pageCategory: 'Patient'
    }
};




// 

if($('.ffb-component-form-container').length > -1) {
    var formLabel = 'farydak-rems';
    formName = formLabel+':receive-updates-about-'+brandName;
    dataLayer.page.formName = formName;
    
    $( document ).ajaxComplete(function() {
        
        // triggered on continue click
        // only present on form steps
        $("#ffb-form-step-index").click();

        // only defined on submit
            if($('.ffb-component-form-container-success').length > 0){
                formResult = formLabel+':form-result:success';
                dataLayer.page.formResult = formResult;
                $("input[name='__RequestVerificationToken']").click();
                // triggered on form success
                // Adobe DTM 'HVCE 2 Day 10' event tule
                $("#successPageHr").click();
            } else if ($('.ffb-component-form-container-duplicate').length > 0){
                formResult = formLabel+':form-result:duplicate';
                dataLayer.page.formResult = formResult;
                $("input[name='__RequestVerificationToken']").click();
                // triggered on form success
                // Adobe DTM 'HVCE 2 Day 10' event tule
            } else if ($('.ffb-component-form-container-failure').length > 0){
                formResult = formLabel+':form-result:error';
                dataLayer.page.formResult = formResult;
                $("input[name='__RequestVerificationToken']").click();
                // triggered on form success
                // Adobe DTM 'HVCE 2 Day 10' event tule
            }
            // triggered on form submitted
            // Adobe DTM 'Form Success' event tule
            

    });

}

$(document).ready(function () {
    /*
    *  Set fileDownload and exitLink vars if clicks on such links
    */
    // fileDownload links
    $('a').on('click', function () {
        var $this = $(this);
        if ($this.parents('.selectpicker').length == 0) {

            var pattern = /^.*\.(docx|DOCX|xlsx|XLSX|xls|doc|DOC|pdf|PDF)$/;
            var ext = $this.attr('href').match(pattern);

            if (ext != null) {
                if (ext[1] == 'docx' || 'DOCX' || 'xlsx' || 'XLSX' || 'xls' || 'doc' || 'DOC' || 'pdf' || 'PDF') {
                    fileDownload = $this.attr('href');
                    dataLayer.page.fileDownload = fileDownload;
                }
            }
        }

    })
    // exit links
    $('a').on('click', function () {
        var href = $(this).attr('href');
        var boolExternalLink = isExternalLink(href);
        if (boolExternalLink) {
            dataLayer.page.exitLink = href;
        }
    })

    function isExternalLink(href) {
        var dataTarget = $(this).data('target');
        var domain = href.split("?");
        if (domain[0].indexOf('http') != -1 && domain[0].indexOf(window.location.hostname) == -1 && dataTarget != "none") {
            return true;
        } else {
            return false;
        }
    }

});