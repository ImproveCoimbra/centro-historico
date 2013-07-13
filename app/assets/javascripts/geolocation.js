var loading_location_message;
var location_found_message;
var location_not_found_message;
var map_container;


if ($('form#new_building').length > 0) {
    loading_location_message = $("#loading_location_message");
    location_found_message = $("#location_found_message");
    location_not_found_message = $("#location_not_found_message");
    map_container = $("#building");
}

function findLocation() {
    loading_location_message.show(500);
    location_not_found_message.hide(500);

    navigator.geolocation.getCurrentPosition(
        foundLocation,
        noLocation,
        { enableHighAccuracy: true, timeout: 30000, maximumAge: 0 }
    );
}

function foundLocation(position) {
    loading_location_message.hide();
    location_found_message.show(500);
    map_container.show();

    var latitude = position.coords.latitude;
    var longitude = position.coords.longitude;
    document.getElementById('latitude').value = latitude;
    document.getElementById('longitude').value = longitude;

    google.maps.event.trigger(Gmaps.map.map, 'resize');

    var latLng = new google.maps.LatLng(latitude, longitude);
    placeMarker(latLng);
    Gmaps.map.map.setCenter(latLng);
}


function noLocation() {
    loading_location_message.hide();
    location_not_found_message.show(500);
    map_container.show();

    var latitude = 40.1950631;
    var longitude = -8.419715912072775;

    document.getElementById('latitude').value = latitude;
    document.getElementById('longitude').value = longitude;

    google.maps.event.trigger(Gmaps.map.map, 'resize');

    var latLng = new google.maps.LatLng(latitude, longitude);
    placeMarker(latLng);
    Gmaps.map.map.setCenter(latLng);
}


