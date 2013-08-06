jQuery ->
    $(document).ready ->
        if $('#map_canvas')? then $('footer').hide()
        adjustToWindow = ->
            takasa = document.height - 125
            yoko = document.width - 370
            $("#map_canvas").css "height", takasa
            $("#map_canvas").css "width", yoko
            $("#postings-list").css "height", takasa
        adjustToWindow()
        
		window.markerMove = (i) ->
            markersArray[i].setAnimation google.maps.Animation.BOUNCE
        window.markerStop = (i) ->
            markersArray[i].setAnimation null