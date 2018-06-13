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
            .fadeIn().delay(2000).fadeOut();
        $(".menuButton").removeClass("btn-light").addClass("btn-primary");
        window.status = true;
    }
    $("#formSelectFileToOpen").find("button[type=submit] > i").attr('hidden', true);
}

function selectMainWindow() {
    $(".mainScreen").fadeOut();
    $("#helloScreen").delay(500).fadeIn(countryListFill);

    return true;

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

    let el = $(`
                <button type="button" class="btn btn-success btn-lg btn-block countrySelector">
                    Stwórz nowy kraj
                </button>
            `);
    el.click(function() {
        editCountry();
    });
    $("#countryListContainer").append(el);

    let allCountryObjects = mainProcess.getXMLCountry();
    for (let i = 0; i < allCountryObjects.length; ++i) {
        if (allCountryObjects[i].name() == "kraj") {
            let current = allCountryObjects[i];
            let el = $(`
                <button type="button" class="btn btn-primary btn-lg btn-block countrySelector">
                    ${getXPathText(current, "n:nazwa")[0]}
                </button>
            `);
            el.click(function() {
                editCountry(current);
            });
            $("#countryListContainer").append(el);

        }
    }




    let regionsObjects = mainProcess.getXMLRegions();
    let optionlist = $("#countryRegion");
    $("#countryRegion option").remove();
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

    $("#countryDelete").off("click").click(function() {
        countryNode.remove();
        updateXML();
        countryListFill();
    });
    $("#countryEditForm").off("submit").submit(function() {
        saveCountry(countryNode, create);
        countryListFill();
        return false;
    });
}

function saveCountry(countryNode, create) {
    if (create) {
        let krajeNode = mainProcess.getXMLCountry()[0].parent();
        mainProcess.addXMLCountryNode({
            nazwa: $("#countryName").val(),
            stolica: {
                nazwa: $("#capitalName").val(),
                szerokosc: [
                    $("#capitalWidth").val().slice(0, -1),
                    $("#capitalWidth").val().slice(-1)
                ],
                wysokosc: [
                    $("#capitalHeight").val().slice(0, -1),
                    $("#capitalHeight").val().slice(-1)
                ],
            },
            populacja: $("#countryPopulation").val(),
            PKB: $("#countryPKB").val(),
            region: $("#countryRegion").val(),
            waluta: $("#countryWaluta").val(),
        });
    } else {
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
    }
    updateXML();
}

function updateXML() {
    let result = mainProcess.updateXML();
    if(result !== "Ok.") {
        $("#mainErrorAlert").removeClass("alert-success")
            .addClass("alert-danger")
            .text(result)
            .fadeIn();
    } else {
        $("#mainErrorAlert").addClass("alert-success")
            .removeClass("alert-danger")
            .text("Zmodyfikowano!")
            .fadeIn(function() {$("#mainErrorAlert").delay(1000).fadeOut();});
    }
}

function ethnicGroupListFill() {
    // Remove all previous content
    $("#ethnicGroupListContainer").html('');

    let allEthnicObjects = mainProcess.getXMLEthnicGroup();
    let el = $(`
                <button type="button" class="btn btn-success btn-lg btn-block">
                    Stwórz nową grupę
                </button>
            `);
    el.click(function() {
        editEthnicGroup();
    });
    $("#ethnicGroupListContainer").append(el);
    for (let i = 0; i < allEthnicObjects.length; ++i) {
        if (allEthnicObjects[i].name() == "grupa-etniczna") {
            let current = allEthnicObjects[i];
            let el = $(`
                <button type="button" class="btn btn-primary btn-lg btn-block">
                    ${getXPathText(current, "@id")[0]}
                </button>
            `);
            el.click(function() {
              console.log(current.name());
                editEthnicGroup(current);
            });
            $("#ethnicGroupListContainer").append(el);

        }
    }

}

function editEthnicGroup(ethnicGroupNode) {
    let create = false;
    if (ethnicGroupNode) {
        $("#ethnicGroupID").val(getXPathText(ethnicGroupNode, "@id")[0]);
    } else {
        create = true;
    }

    $("#ethnicGroupDelete").off("click").click(function() {
        mainProcess.getXMLCountry().forEach(function(x) {
            x.find("n:grupy-etniczne/n:grupa-etniczna[@idref='" +
                   ethnicGroupNode.get("@id", xmlnamespaces).value() + "']",
                   xmlnamespaces).forEach(function(x) {
                       x.remove();
                   });
        });
        ethnicGroupNode.remove();
        updateXML();
        ethnicGroupListFill();
    });
    $("#ethnicGroupEditForm").off("submit").submit(function() {
        saveEthnicGroup(ethnicGroupNode, create);
        ethnicGroupListFill();
        return false;
    });
}

function saveEthnicGroup(ethnicGroupNode, create) {
    if (create) {
        console.log("Create");
          mainProcess.addXMLEthnicGroupNode({
              nazwaID: $("#ethnicGroupID").val(),
          });
          //let currentEthnicGroups = mainProcess.getXMLEthnicGroup();
    } else {
        let allCountryObjects = mainProcess.getXMLCountry();
        for (let i = 0; i < allCountryObjects.length; ++i) {
            console.log(allCountryObjects[i].toString());
            try {
                allCountryObjects[i]
                    .find("n:grupy-etniczne/n:grupa-etniczna[@idref='" +
                          ethnicGroupNode.get("@id", xmlnamespaces).value() + "']",
                          xmlnamespaces)
                    .forEach(function (x) {
                        x.get("@idref").value($("#ethnicGroupID").val());
                    });
            } catch(err) {
                console.log(err);
            }
        }
        ethnicGroupNode.get("@id", xmlnamespaces).value($("#ethnicGroupID").val());
    }
    updateXML();
}
