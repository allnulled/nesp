const fs = require("fs");
const contenido = require(__dirname + "/../src/def.js").parse(fs.readFileSync(__dirname + "/def.ensam").toString());
console.log(JSON.stringify(contenido, null, 4));