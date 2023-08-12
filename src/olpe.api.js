(function(factoria, scope) {
    const nombre = "OLPE";
    const modulo = factoria();
    if(typeof window !== "undefined") window[nombre] = modulo;
    if(typeof global !== "undefined") global[nombre] = modulo;
    if(typeof module !== "undefined") module.exports = modulo;
    if(typeof scope !== "undefined") scope[nombre] = modulo;
})(function() {
    
    class OLPE {
        static transpile(file, options) {
            const codigo = require("fs").readFileSync(file).toString();
            const parser = require(__dirname + "/def.js");
            const ast = parser.parse(codigo);
            const olpe_interpreter = require(__dirname + "/olpe.interpret.js");
            const codigo_asm = olpe_interpreter.interpret(ast);
            return codigo_asm;
        }
        static compile(file, options) {
            const child_process = require("child_process");
            const fichero_ejecutable = this.transpile(file, options);
            const fichero_asm = file + ".asm";
            const fichero_obj = file + ".o";
            const fichero_bin = file + ".bin";
            fs.writeFileSync(fichero_asm, fichero_ejecutable, "utf8");
            const comando_1 = `nasm -f elf64 -o ${JSON.stringify(fichero_obj)} ${JSON.stringify(fichero_asm)}`;
            const comando_2 = `ld ${JSON.stringify(fichero_obj)} -o ${JSON.stringify(fichero_bin)}`;
            const stdio = [process.stdin, process.stdout, process.stderr];
            child_process.execSync(comando_1, { cwd: process.cwd(), stdio });
            child_process.execSync(comando_2, { cwd: process.cwd(), stdio });
            return require("path").resolve(process.cwd(), fichero_bin);
        }
        static execute(file, args, options) {
            const fichero_ejecutable = this.compile(file, options);
            const stdio = [process.stdin, process.stdout, process.stderr];
            child_process.execSync(`${JSON.stringify(fichero_ejecutable)}`, { cwd: process.cwd(), stdio });
        }
    }
    
    OLPE.default = OLPE;

    return OLPE;

}, this);