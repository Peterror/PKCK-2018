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

function updateXML() {
    if (!fileContent.validate(schemaContent))
        return "Cannot validate changes";

    fs.writeFileSync("newXML.xml", fileContent.toString());
    return "Ok.";
}

exports.dialogSelectXMLFile = dialogSelectXMLFile;
exports.loadXMLFile = loadXMLFile;
exports.getXMLCountry = getXMLCountry;
exports.getXMLRegions = getXMLRegions;
exports.updateXML = updateXML;

app.on('ready', createWindow);
