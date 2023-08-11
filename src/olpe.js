(function(factoria) {
    const nombre = "OLPE";
    const modulo = factoria();
    if(typeof window !== "undefined") window[nombre] = modulo;
    if(typeof global !== "undefined") global[nombre] = modulo;
    if(typeof module !== "undefined") module.exports = modulo;
})(function() {
    
    class OLPE {
        static transpile(file, options) {
            const codigo = require("fs").readFileSync(file).toString();
            const parser = require(__dirname + "/def.js");
            const ast = parser.parse(codigo);
            const interpreter = require(__dirname + "/def.ast.js");
            const codigo_asm = interpreter.interpret(ast);
            return codigo_asm;
        }
        static compile(file, options) {
            const fichero_ejecutable = this.transpile(file, options);
            // temporal: //////////////////////////////////
            fs.writeFileSync(file + ".asm", fichero_ejecutable, "utf8");
        }
        static execute(file, options) {
            const fichero_ejecutable = this.compile(file, options);
        }
    }
    
    OLPE.default = OLPE;

    return OLPE;

});