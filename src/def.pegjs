Lenguage = Bloque

  /************/
 /* LENGUAJE */
/************/

Bloque = _* Sentencia* _*
Bloque_en_parentesis = 
  token1:OPEN_CURLY_BRACKETS
  bloque:Bloque
  token2:CLOSE_CURLY_BRACKETS
    { return bloque }
Sentencia = Sentencia_completa

  /**************/
 /* SENTENCIAS */
/**************/

Sentencia_completa = sentencia:(
  Sentencia_de_defino_global /
  Sentencia_de_inicio_seccion / 
  Sentencia_de_inicio_bloque / 
  Sentencia_de_asigno /
  Sentencia_de_interrumpo /
  Sentencia_de_simbolizo /
  Sentencia_de_defino_byte )
    { return sentencia }
  
Sentencia_de_inicio_seccion = 
  token1:(_* "Inicio sección" _+)
  etiqueta:Etiqueta_prebloque
  bloque:Bloque_en_parentesis
  token4:(EOS _*)
    { return etiqueta }

Sentencia_de_simbolizo = 
token1:(_* "Simbolizo" _+)
  etiqueta:Nombre_de_variable
  token2:(_+ "como" _+)
  conjunto:Expresion_de_valor
  token3:(EOS _*)
    { return etiqueta }

Sentencia_de_defino_byte = 
  token1:(_* "Defino byte" _+)
  etiqueta:Nombre_de_variable
  token2:(_+ "como" _+)
  conjunto:Conjunto_de_valores_seguidos
  token3:(EOS _*)
    { return etiqueta }

Sentencia_de_inicio_bloque = 
  token1:(_* "Inicio bloque" _+)
  etiqueta:Etiqueta_prebloque
  bloque:Bloque_en_parentesis
  token4:(EOS _*)
    { return etiqueta }

Sentencia_de_defino_global = 
  token1:(_* "Defino global" _+)
  etiqueta:Etiqueta_prepunto
  token2:(EOS _*)
    { return etiqueta }

Sentencia_de_asigno =
  token1:(_* "Asigno" _+)
  origen:Referencia_a_registro
  token2:(_+ "como" _+)
  destino:Referencia_a_valor
  token3:(EOS _*)
    { return { origen, destino } }

Sentencia_de_interrumpo =
  token1:(_* "Interrumpo con" _+)
  referencia:Referencia_a_valor
  token2:(EOS _*)
    { return referencia }

Nombre_de_variable = Referencia_a_valor_de_variable

Referencia_a_valor = referencia:(
    Referencia_a_valor_de_variable /
    Referencia_a_valor_de_numero_hexadecimal /
    Referencia_a_valor_de_numero /
    Referencia_a_valor_de_texto /
    Referencia_a_signo_de_dolar_doble /
    Referencia_a_signo_de_dolar /
    Referencia_a_registro
  ) { return referencia }
Referencia_a_registro =
  "registro "
  registro:TOKEN_DE_REGISTRO
    { return registro }
Referencia_a_valor_de_variable =
  [A-Za-z] [A-Za-z0-9]*
    { return text() }
Referencia_a_valor_de_numero_hexadecimal =
  ("0x" / "0X") [0-9]+
    { return text() }
Referencia_a_valor_de_numero =
  [0-9]+
    { return text() }
Referencia_a_valor_de_texto = 
  '"' (!('"'/'\\"').)* '"'
    { return text() }
Referencias_a_valores_precedidos_por_coma =
  valores:Referencia_a_valor_precedido_por_coma
    { return valores }
Referencia_a_valor_precedido_por_coma =
  token1:(_* "," _*)
  valor:Referencia_a_valor
    { return valor }
Referencia_a_signo_de_dolar = "$"
    { return "$" }
Referencia_a_signo_de_dolar_doble = "$$"
    { return "$$" }

Conjunto_de_valores_seguidos = 
  valor1:Referencia_a_valor
  valoresN:Referencias_a_valores_precedidos_por_coma
    { return valor1 + valoresN }

Expresion_de_valor =
  token1:(_*)
  valor1:Referencia_a_valor
  valor2:Operaciones_a_valor
    { return { valor1, valor2 } }

Operaciones_a_valor =
  token1:(_*)
  operador:("-" / "+")
  token2:(_*)
  operante:Referencia_a_valor
    { return { operador, operante } }

Etiqueta_prebloque = ((!("{")).)+
     { return text() }
Etiqueta_prepunto = ((!(".")).)+
     { return text() }

  /*********************/
 /* TOKENS ESPECIALES */
/*********************/

_ = (__ / ___ / Comentarios) {}
__ = ("\r" / "\n") {}
___ = ("\t" / " ") {}

OPEN_CURLY_BRACKETS = _* "{" _*
CLOSE_CURLY_BRACKETS = _* "}" _*
EOS = "."
EOL = __+

Comentarios = comentario:(
  Comentario_unilinea / 
  Comentario_multilinea )
    { return comentario }

Comentario_unilinea = "//" (!(EOL).)* EOL*
Comentario_multilinea = "/*" (!("*/").)* "*/"

TOKEN_DE_REGISTRO = registro:(
  TOKEN_DE_REGISTRO_DE_CPU
  / TOKEN_DE_REGISTRO_DE_PUNTERO )
    { return registro }  
TOKEN_DE_REGISTRO_DE_PUNTERO = ("0x" / "0X") [0-9]
TOKEN_DE_REGISTRO_DE_CPU = [A-Za-z]*