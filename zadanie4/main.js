const electron = require('electron');
const fs = require('fs');
const xml = require('libxmljs');
const exec = require('child_process').execSync;
const app = electron.app;
const remote = electron.remote;
const BrowserWindow = electron.BrowserWindow;

var fileContent = "";
var fileContentBak = "";
var schemaContent = xml.parseXml(
    fs.readFileSync("schema.xsd", "utf-8"));

const xmlnamespaces = {n: "file://root.zadanie2/"};

function createWindow() {
    win = new BrowserWindow({width: 800, height: 600});
    win.loadFile('frontend/index.html');
    win.webContents.openDevTools();
}

function node2json(xmlnode) {
    let r = {
        name: xmlnode.name(),
        attrs: xmlnode.attrs().map(attr2json),
        child: xmlnode.childNodes().map(node2json),
        ns: xmlnode.namespace()
    };

    if (r.name == "text")
        r.text = xmlnode.text();

    return r;
}

function attr2json(attrnode) {
    return {
        name: attrnode.name(),
        value: attrnode.value(),
        ns: attrnode.namespace()
    };
}

function dialogSelectXMLFile(win) {
    return electron.dialog.showOpenDialog(win, {
        title: "Select XML file",
        defaultPath: app.getAppPath() + "../",
        properties: ['openFile'],
        filters: [
            {name: 'XML files', extensions: ['xml']}
        ]
    });
}

function loadXMLFile(filepath) {
    if (!fs.existsSync(filepath))
        return "Podany plik nie istnieje.";

    fileContent = xml.parseXml(
        fs.readFileSync(filepath, "utf-8"));

    if (!fileContent.validate(schemaContent))
        return "Nie można zwalidować pliku na podstawie xml schema!\n" +
        fileContent.validationErrors;
    return "Ok.";
}

function getXMLCountry() {
    return fileContent.find("/n:dokument/n:kraje/n:kraj", xmlnamespaces);
}

function getXMLRegions() {
    return fileContent.find("/n:dokument/n:regiony/n:region", xmlnamespaces);
}

function getXMLEthnicGroup() {
    return fileContent.find("/n:dokument/n:grupy-etniczne/n:grupa-etniczna", xmlnamespaces);
}

function updateXML() {
    if (!fileContent.validate(schemaContent)) {
        return "Cannot validate changes" + fileContent.validationErrors;
    }

    fs.writeFileSync("newXML.xml", fileContent.toString());
    return "Ok.";
}

function addXMLCountryNode(data) {
    let subroot = fileContent.get("/n:dokument/n:kraje", xmlnamespaces);
    let krajNode = subroot.node("kraj").node("nazwa", data.nazwa)
        .parent().node("stolica").node("nazwa", data.stolica.nazwa).parent()
        .node("współrzędne")
        .node("wysokość", data.stolica.wysokosc[0]).attr({typ: data.stolica.wysokosc[1]}).parent()
        .node("szerokość", data.stolica.szerokosc[0]).attr({typ: data.stolica.szerokosc[1]}).parent()
        .parent().parent()
        .node("grupy-etniczne").parent()
        .node("strefy-czasowe").parent()
        .node("ważne-wydarzenia").parent()
        .node("populacja", data.populacja).attr({jednostka: "osoba"}).parent()
        .node("PKB", data.PKB).attr({waluta: "USD", jednostka: "mld"}).parent()
        .node("waluta", data.waluta).parent()
        .node("region").attr({idref: data.region});

    fileContent = xml.parseXml(fileContent.toString());
}

exports.dialogSelectXMLFile = dialogSelectXMLFile;
exports.loadXMLFile = loadXMLFile;
exports.getXMLCountry = getXMLCountry;
exports.getXMLRegions = getXMLRegions;
exports.getXMLEthnicGroup = getXMLEthnicGroup;
exports.updateXML = updateXML;
exports.addXMLCountryNode = addXMLCountryNode;

app.on('ready', createWindow);
