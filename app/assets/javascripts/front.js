jQuery(function ($) {

  // Only run if there's a map on the front section
  if ($("#front #map").length > 0) {

    var currentBounds;

    function getFilterCriteria() {
      return $('#criteria .accordion-body.in').data('criteria');
    }

    // Gmaps4Rails update markers based on window
    function updateMarkers() {
      Gmaps.map.map.setTilt(0);

      //Gmaps.map.adjustMapToBounds();
      var bounds= Gmaps.map.map.getBounds();

      var sw = bounds.getSouthWest();
      var ne = bounds.getNorthEast();

      if (currentBounds != null && (currentBounds.contains(sw) && currentBounds.contains(ne)) ) {
        //Nothing to do
        return;
      }

      var latDiff = Math.abs(sw.lat() - ne.lat());
      var lngDiff = Math.abs(sw.lng() - ne.lng());

      //Move the corners in the direction by half the size
      bounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(sw.lat() - latDiff/2, sw.lng() - lngDiff/2),
        new google.maps.LatLng(ne.lat() + latDiff/2, ne.lng() + lngDiff/2)
      );

      sw = bounds.getSouthWest();
      ne = bounds.getNorthEast();

      currentBounds = bounds;

      var criteria = getFilterCriteria();
      var data = {'northEast': ne.toUrlValue(15), 'southWest': sw.toUrlValue(15), 'criteria': criteria};

      $.getJSON('/buildings.json', data, function (json) {
        Gmaps.map.replaceMarkers(json, false);
      });

    }

    Gmaps.map.callback = function() {
      //Gmaps.map.markers_conf.do_clustering = true;
      // Map fully loaded here
      google.maps.event.addListenerOnce(Gmaps.map.serviceObject, 'idle', updateMarkers);
      google.maps.event.addListener(Gmaps.map.serviceObject, 'bounds_changed', updateMarkers);
      Gmaps.map.map.setOptions({
        panControl: false,
        zoomControl: true,
        zoomControlOptions: {position: google.maps.ControlPosition.RIGHT_BOTTOM}
      });
    }

    $('#criteria .accordion-toggle').on('click', function (event) {
      if ($(this).parents('.accordion-group').children('.accordion-body').hasClass('in')) {
        event.stopPropagation();
        return false;
      }
    });

    $('#criteria .accordion-body').on('shown', function () {
      currentBounds = null; // force update
      updateMarkers();
    });

  }

});
