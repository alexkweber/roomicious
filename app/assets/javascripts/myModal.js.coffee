jQuery ->
    $("#myModal").on 'hide', =>
        $("#myModal").animate { scrollTop: 0 }, "fast"