// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require dropzone.min
//= require jquery.turbolinks
//= require twitter/bootstrap
//= require turbolinks
//= require wysihtml5
//= require bootstrap-wysihtml5
//= require_tree .

$(document).ready(function() {

  $( "#popup" ).dialog({
      autoOpen: false,

      width: 500,
      modal: true,
      close: function() {
      }
    });

  $('.wysiwyg').wysihtml5({supportTouchDevices:  true});

});


function sticky_relocate() {
    var window_top = $(window).scrollTop();
    var div_top = $('#sticky-anchor').offset().top + 0;
    if (window_top > div_top) {
        $('.sticky').addClass('stick');
        $('#sticky-anchor').height($('.sticky').outerHeight());
    } else {
        $('.sticky').removeClass('stick');
        $('#sticky-anchor').height(0);
    }
}

$(function() {
    $(window).scroll(sticky_relocate);
    sticky_relocate();
});
