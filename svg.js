function selectCountry(country_id) {
    var elements = document.getElementsByClassName("navselected");
    console.log(elements);
    for (var i = 0; i < elements.length; ++i) {
        elements[i].classList.remove("navselected");
    }

    var current = document.getElementById(country_id + "-bar");
    current.classList.add("navselected");

    var meta = document.getElementsByClassName("metadata");
    for (i = 0; i < meta.length; ++i) {
        meta[i].style.visibility = 'hidden';
    }
    document.getElementById(country_id + "-desc").style.visibility = 'visible';
}
