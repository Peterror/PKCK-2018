'use strict';

window.$ = window.jQuery = require('jquery');
window.Bootstrap = require('bootstrap');

const electron = require('electron');
const mainProcess = electron.remote.require('./main');
const xmlnamespaces = {n: "file://root.zadanie2/"};
window.status = false;

function onClickOpenFileBrowser() {
    let value = mainProcess.dialogSelectXMLFile();
    $("#formSelectFileToOpen").find("#mainFilename").val(value);
}

function onClickLoadFile() {
    $("#formSelectFileToOpen").find("button[type=submit] > i").removeAttr('hidden');
    let filename = $("#formSelectFileToOpen").find("#mainFilename").val();
    let status = mainProcess.loadXMLFile(filename);
    if(status !== "Ok.") {
        $("#mainErrorAlert").removeClass("alert-success")
            .addClass("alert-danger")
            .text(status)
            .fadeIn();
        $(".menuButton").addClass("btn-light").removeClass("btn-primary");
    } else {
        $("#mainErrorAlert").addClass("alert-success")
            .removeClass("alert-danger")
            .text("Pomyślnie wczytano plik XML, możesz przystąpić do edycji.")
            .fadeIn();
        $(".menuButton").removeClass("btn-light").addClass("btn-primary");
        window.status = true;
    }
    $("#formSelectFileToOpen").find("button[type=submit] > i").attr('hidden', true);
}

function selectEditCountryWindow() {
    if (window.status === "false") {
        return false;
    }
    $(".mainScreen").fadeOut();
    $("#editCountryScreen").delay(500).fadeIn(countryListFill);

    return true;
}

function selectEditEthnicGroupWindow() {
    if (window.status === "false") {
        return false;
    }
    $(".mainScreen").fadeOut();
    $("#editEthnicGroupScreen").delay(500).fadeIn(ethnicGroupListFill);

    return true;
}

function getXPathText(node, path) {
    return node.find(path, xmlnamespaces).map(function(x) {
        if(x.text)
            return x.text();
        if (x.value)
            return x.value();
        return null;
    });
}

function countryListFill() {
    // Remove all previous content
    $("#countryListContainer").html('');

    let allCountryObjects = mainProcess.getXMLCountry();
    for (let i = 0; i < allCountryObjects.length; ++i) {
        if (allCountryObjects[i].name() == "kraj") {
            let current = allCountryObjects[i];
            let el = $(`
                <button type="button" class="btn btn-primary btn-lg btn-block">
                    ${getXPathText(current, "n:nazwa")[0]}
                </button>
            `);
            el.click(function() {
                editCountry(current);
            });
            $("#countryListContainer").append(el);

        }
    }
    let el = $(`
                <button type="button" class="btn btn-primary btn-lg btn-block">
                    Stwórz nowy kraj
                </button>
            `);
    el.click(function() {
        saveCountry(null, true);
    });
    $("#countryListContainer").append(el);



    let regionsObjects = mainProcess.getXMLRegions();
    let optionlist = $("#countryRegion");
    for (let i = 0; i < regionsObjects.length; ++i) {
        if (regionsObjects[i].name() == "region") {
            let current = regionsObjects[i];
            optionlist.append(`<option>${getXPathText(current, "@id")[0]}</option>`);
        }
    }
}

function editCountry(countryNode) {
    let create = false;
    if (countryNode) {
        $("#countryName").val(getXPathText(countryNode, "n:nazwa")[0]);
        $("#capitalName").val(getXPathText(countryNode, "n:stolica/n:nazwa")[0]);
        $("#capitalHeight").val(getXPathText(countryNode, "n:stolica/n:współrzędne/n:wysokość")[0]
                                + getXPathText(countryNode, "n:stolica/n:współrzędne/n:wysokość/@typ")[0]);
        $("#capitalWidth").val(getXPathText(countryNode, "n:stolica/n:współrzędne/n:szerokość")[0]
                               + getXPathText(countryNode, "n:stolica/n:współrzędne/n:szerokość/@typ")[0]);
        $("#countryPopulation").val(getXPathText(countryNode, "n:populacja")[0]);
        $("#countryWaluta").val(getXPathText(countryNode, "n:waluta")[0]);
        $("#countryPKB").val(getXPathText(countryNode, "n:PKB")[0]);
        $("#countryRegion").val(getXPathText(countryNode, "n:region/@idref")[0]);
    } else {
        create = true;
    }

    $("#countryDelete");
    $("#countryEditForm").submit(function() {
        saveCountry(countryNode, create);
        countryListFill();
        return false;
    });
}

function saveCountry(countryNode, create) {
    if (create) {
        console.log(mainProcess.getXMLCountry()[0].parent()
                    .node("kraj").node("nazwa", "nowy").parent()
                    .node("stolica").node("nazwa").parent().node("współrzędne")
                    .node("wysokość").attr({typ: "N"}).parent()
                    .node("szerokość").attr({typ: "E"}).parent().parent().parent());
        let currentCountries = mainProcess.getXMLCountry();
        for (let i = 0; i < currentCountries.length; ++i) {
            console.log(getXPathText(currentCountries[i], "n:nazwa")[0])
                console.log("Znalazłem!");
        }
    }
    countryNode.get("n:nazwa", xmlnamespaces).text($("#countryName").val());
    countryNode.get("n:stolica/n:nazwa", xmlnamespaces).text($("#capitalName").val());
    countryNode.get("n:stolica/n:współrzędne/n:wysokość", xmlnamespaces)
        .text($("#capitalHeight").val().slice(0, -1));
    countryNode.get("n:stolica/n:współrzędne/n:szerokość", xmlnamespaces)
        .text($("#capitalWidth").val().slice(0, -1));
    countryNode.get("n:stolica/n:współrzędne/n:wysokość/@typ", xmlnamespaces)
        .value($("#capitalHeight").val().slice(-1));
    countryNode.get("n:stolica/n:współrzędne/n:szerokość/@typ", xmlnamespaces)
        .value($("#capitalWidth").val().slice(-1));
    countryNode.get("n:populacja", xmlnamespaces).text($("#countryPopulation").val());
    countryNode.get("n:waluta", xmlnamespaces).text($("#countryWaluta").val());
    countryNode.get("n:PKB", xmlnamespaces).text($("#countryPKB").val());
    countryNode.get("n:region/@idref", xmlnamespaces).value($("#countryRegion").val());

    mainProcess.updateXML();
}

function ethnicGroupListFill() {
    // Remove all previous content
    $("#ethnicGroupListContainer").html('');

    let allEthnicObjects = mainProcess.getXMLEthnicGroup();
    for (let i = 0; i < allEthnicObjects.length; ++i) {
        if (allEthnicObjects[i].name() == "grupa-etniczna") {
            let current = allEthnicObjects[i];
            let el = $(`
                <button type="button" class="btn btn-primary btn-lg btn-block">
                    ${getXPathText(current, "@id")[0]}
                </button>
            `);
            el.click(function() {
                editEthnicGroup(current);
            });
            $("#ethnicGroupListContainer").append(el);

        }
    }
    let el = $(`
                <button type="button" class="btn btn-primary btn-lg btn-block">
                    Stwórz nową grupę etniczną
                </button>
            `);
    el.click(function() {
        saveEthnicGroup(null, true);
    });
    $("#ethnicGroupListContainer").append(el);
}

function editEthnicGroup(ethnicGroupNode) {
    let create = false;
    if (ethnicGroupNode) {
        $("#ethnicGroupID").val(getXPathText(ethnicGroupNode, "@id")[0]);
    } else {
        create = true;
    }

    $("#ethnicGroupDelete");
    $("#ethnicGroupEditForm").submit(function() {
        saveEthnicGroup(ethnicGroupNode, create);
        ethnicGroupListFill();
        return false;
    });
}

function saveEthnicGroup(ethnicGroupNode, create) {
    if (create) {
		// Następnej linijki nie ogarniam
        console.log(mainProcess.getXMLEthnicGroup()[0].parent()); 
		
        let currentEthnicGroups = mainProcess.getXMLEthnicGroup();
        for (let i = 0; i < currentEthnicGroups.length; ++i) {
            console.log(getXPathText(currentEthnicGroups[i], "@id")[0])
                console.log("Znalazłem!");
        }
    }
    ethnicGroupNode.get("@id", xmlnamespaces).text($("#ethnicGroupID").val());

    mainProcess.updateXML();
}
