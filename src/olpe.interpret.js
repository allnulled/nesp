(function (factoria, scope) {
    const nombre = "OLPE";
    const modulo = factoria();
    if (typeof window !== "undefined") window[nombre] = modulo;
    if (typeof global !== "undefined") global[nombre] = modulo;
    if (typeof module !== "undefined") module.exports = modulo;
    if (typeof scope !== "undefined") scope[nombre] = modulo;
})(function () {

    class OLPE_Interpret {

        interpret_ast(ast) {
            console.log(ast);
        }

    }

    OLPE_Interpret.default = OLPE_Interpret

    return OLPE_Interpret;

});