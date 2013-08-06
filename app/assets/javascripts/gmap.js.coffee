window.markersArray = []

loadScript = ->
    script = document.createElement "script"
    script.type = "text/javascript"
    script.src = "http://maps.googleapis.com/maps/api/js?key=AIzaSyCZ8jAIOXmv48gHaisTFT_gfBHzgfnJ3l4&sensor=false&callback=initialize"
    document.body.appendChild script

if window.location.pathname is '/'
    window.onload = loadScript()
    
window.initialize = (center) ->
    place_coor = [37.3229978, -122.0321823]
    window.map = new google.maps.Map( $("#map_canvas")[0], {
        zoom: 12,
        center: new google.maps.LatLng( place_coor[0], place_coor[1] ),
        mapTypeId: google.maps.MapTypeId.ROADMAP
    })
    # Add listener for bounds changes
    # google.maps.event.addListener( window.map, 'bounds_changed', (map) ->
    #   bounds = this.getCenter()
    #   $.ajax({
    #     type: 'POST'
    #     url:'/'
    #     data: {
    #       'lat': bounds.Xa
    #       'lon': bounds.Ya
    #     }
    #   })
    # )
    
    window.dropMarkers()

window.dropMarkers = -> # Have to fix to show all items in the map view.
    postInfo = $(".post-info")
    postings = $(".posting")
    photos = $(".post-photo")
    infowindow = new google.maps.InfoWindow()
    
    for post, i in postings
        #Get coordinates.
        geo = post.getAttribute("geo").split(' ')
        #Create a marker
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(geo[0], geo[1]),
            animation: google.maps.Animation.DROP,
            map: window.map
        })
        #Add to list of markers
        window.markersArray.push marker
        
        #sets infoWindows for each of the markers dropped to the map
        google.maps.event.addListener( marker, 'click', do (marker, i) ->
            ->
                postURL = post.getAttribute('href')
                photo = photos[i].innerHTML                
                name = $(".post-info")[i].firstChild.data
                infowindow.setContent(
                    "<div class='infowindow'><center>#{photo}</center>"+
                    "<b>#{name}</b><br />"+
                    "<a href=#{postURL} data-remote='true'>#{post.innerHTML}</a></div>"
                )
                infowindow.open window.map, marker
        )
                
window.clearMarkers = ->
    for marker in window.markersArray
        marker.setMap(null)
    window.markersArray = []