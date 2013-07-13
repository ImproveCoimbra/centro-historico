/* globals jQuery, Gmaps */
jQuery(function ($) {
  "use strict";

  if ($("#home").length == 0) { return; } // Only run on homepage

  var jQueryCache, headerHeight, footerHeight, ajdustSize, lastHeight;

  jQueryCache = {
    'window' : $(window),
    '.gmaps4rails_map, .map-container' : $('.gmaps4rails_map, .map-container'),
    'header' : $('header'),
    'footer' : $('footer')
  };

  ajdustSize = function () {
    var height, windowHeight;

    windowHeight = jQueryCache.window.height();
    headerHeight = jQueryCache.header.outerHeight();
    footerHeight = jQueryCache.footer.outerHeight();

    height = windowHeight - headerHeight - footerHeight;

    if (height === lastHeight || height < 200) {
        //If the height does not change bail out
        return;
    }

    lastHeight = height;

    jQueryCache['.gmaps4rails_map, .map-container'].css('height', height + 'px');
  };

  ajdustSize();

  //Probably we should throtle this
  jQueryCache.window.bind('resize', ajdustSize);

  // Map Load callback
  Gmaps.map.callback = function() {

    for (var i = 0; i <  this.markers.length; ++i) {
      var marker = Gmaps.map.markers[i];

      var onMarkerClick = function onMarkerClick(marker){
        return function(){
          window.location = marker.link;
        }
      };

      // Click on marker to open show view
      google.maps.event.addListener(marker.serviceObject, 'click', onMarkerClick(marker));
    }
  };

});
