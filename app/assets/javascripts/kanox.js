(function ($) {
  "use strict";
  $(document).ready(function() {

    var sync3 = $("#sync3");
    var sync4 = $("#sync4");

    sync3
      .on('initialized.owl.carousel', function() {
        // sync3.find(".owl-item").eq(0).addClass("current");
      })
      .owlCarousel({
        items: 1,
        dots: true,
        smartSpeed: 2000,
        nav: false,
        autoplay:true,
        autoplayTimeout:10000,
        autoplayHoverPause:true,
        loop: true,
        animateOut: 'flipOutY',mouseDrag: true
      });

    sync4
      .on('initialized.owl.carousel', function() {
        // sync3.find(".owl-item").eq(0).addClass("current");
      })
      .owlCarousel({
        items: 1,
        dots: true,
        smartSpeed: 2000,
        nav: false,
        autoplay:true,
        autoplayTimeout:10000,
        autoplayHoverPause:true,
        loop: true,
        animateOut: 'rollOut',
        animateIn: 'rollIn',
      });

  });

}(jQuery));