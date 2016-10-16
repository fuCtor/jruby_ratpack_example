$(function(){

    var tpl = $('#result_tpl').find('div')
    var results = $("#results")

    var expandUrl = function(e){
        var url = $("#url").val();
        $.get("/expand?url="+ url, function(data){
            for(var url in data) {
                console.log (data[url]);
                var new_row = tpl.clone();
                $('.start', new_row).html(url)
                $('.finish', new_row).html(data[url].slice(-1)[0] )

                results.append(new_row);

            }
        })
        e.preventDefault();
        return false;
    }

    $("#sendButton").on("click", expandUrl)
    $("form").on("submit", expandUrl)

})