Test_de_parseo_de_codigo: {
    const fs = require("fs");
    const contenido_origen = fs.readFileSync(__dirname + "/hello.olpe").toString();
    const contenido = require(__dirname + "/../src/olpe.parser.js").parse(contenido_origen);
    console.log(JSON.stringify(contenido, null, 4));
};