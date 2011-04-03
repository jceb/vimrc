#AUTHOR:   Greg Sexton <gregsexton@gmail.com>
#WEBSITE:  https://github.com/gregsexton/VimCalc
#VERSION:  1.3, for Vim 7.0+
#LICENSE:  Same terms as Vim itself (see :help license).

import math, re, random

#### LEXICAL ANALYSIS FUNCTIONS ##################################################

#lexemes
#digit  = [0-9]
#digits = digit+

#uppercase = [A-Z]
#lowercase = [a-z]

#alpha        = (uppercase|lowercase)
#alphanumeric = (alpha|digits)

#hexdigit  = [0-9a-fA-F]
#hexdigits = hexdigit+

#octdigit  = [0-7]
#octdigits = octdigit+

#decnumber   = digits(. digits)?(e[+-]? digits)?
#hexnumber   = 0xhexdigits
#octalnumber = 0 octdigits

#whitespace = [\t ]+

#ident = (alpha|_)(alphanumeric|_)*'?

#plus      = '+'
#subtract  = '-'
#multiply  = '*'
#divide    = '/'
#modulo    = '%'
#exponent  = '**'
#lShift    = '<<'
#rShift    = '>>'
#factorial = '!'

#unaryOp  = factorial
#binaryOp = plus|subtract|multiply|divide|modulo|exponent|lShift|rShift
#operator = unaryOp|binaryOp

#lParen    = '('
#rParen    = ')'
#comma     = ','
#assign    = '='
#pAssign   = '+='
#sAssign   = '-='
#mAssign   = '*='
#dAssign   = '/='
#modAssign = '%='
#expAssign = '**='

#delimiters = lParen|rParen|comma|assign|pAssign|sAssign|mAssign|dAssign|modAssign|expAssign

#let = 'let'
#keywords = let

#decDir     = ':dec'
#hexDir     = ':hex'
#octDir     = ':oct'
#intDir     = ':int'
#floatDir   = ':float'
#statusDir  = ':status' | ':s'
#varDir     = ':vars'
#quitDir    = ':q'
#directives = decDir | hexDir | octDir | intDir | floatDir | statusDir | varDir | quitDir

class Token(object):
    def __init__(self, tokenID, attrib):
        self._tokenID = tokenID
        self._attrib = attrib
    def __repr__(self):
        return str(self._tokenID) + ':' + str(self._attrib)
    def __str__(self):
        return str(self._tokenID) + ':' + str(self._attrib)
    def getID(self):
        return self._tokenID
    def getAttrib(self):
        return self._attrib
    ID = property(getID, doc='Token ID [string].')
    attrib = property(getAttrib, doc='Token attribute [string].')

class Lexeme(object):
    def __init__(self, identifier, regex):
        self._ID = identifier
        self._regex = regex
    def getID(self):
        return self._ID
    def getRegex(self):
        return self._regex
    ID = property(getID, doc='Lexeme ID [string].')
    regex = property(getRegex, doc='Regex to match the Lexeme.')

#language lexemes NOTE: don't change these without changing syntax file
lexemes = [Lexeme('whitespace', r'\s+'),
           Lexeme('hexnumber',  r'0x[0-9a-fA-F]+'),
           Lexeme('octnumber',  r'0[0-7]+'),
           Lexeme('decnumber',  r'[0-9]+(\.[0-9]+)?(e[+-]?[0-9]+)?'),
           Lexeme('let',        r'let'),
           Lexeme('ident',      r"[A-Za-z_][A-Za-z0-9_]*'?"),
           Lexeme('expAssign',  r'\*\*='),
           Lexeme('modAssign',  r'%='),
           Lexeme('dAssign',    r'/='),
           Lexeme('mAssign',    r'\*='),
           Lexeme('sAssign',    r'-='),
           Lexeme('pAssign',    r'\+='),
           Lexeme('lShift',     r'<<'),
           Lexeme('rShift',     r'>>'),
           Lexeme('exponent',   r'\*\*'),
           Lexeme('assign',     r'='),
           Lexeme('comma',      r','),
           Lexeme('lParen',     r'\('),
           Lexeme('rParen',     r'\)'),
           Lexeme('factorial',  r'!'),
           Lexeme('modulo',     r'%'),
           Lexeme('divide',     r'/'),
           Lexeme('multiply',   r'\*'),
           Lexeme('subtract',   r'-'),
           Lexeme('plus',       r'\+'),
           Lexeme('decDir',     r':dec'),
           Lexeme('hexDir',     r':hex'),
           Lexeme('octDir',     r':oct'),
           Lexeme('statusDir',  r':status'),
           Lexeme('statusDir',  r':s'),         #shorthand
           Lexeme('varDir',     r':vars'),
           Lexeme('quitDir',    r':q'),
           Lexeme('intDir',     r':int'),
           Lexeme('floatDir',   r':float') ]

#takes an expression and uses the language lexemes
#to produce a sequence of tokens
def tokenize(expr):
    tokens = []
    while expr != '':
        matchedLexeme = False
        for lexeme in lexemes:
            match = matchesFront(lexeme.regex, expr)
            if match != '':
                tokens.append(Token(lexeme.ID, match))
                expr = expr[len(match):]
                matchedLexeme = True
                break
        if not matchedLexeme: return [Token('ERROR', expr)]
    return filter(lambda t: t.ID != 'whitespace', tokens)

#returns the match if regex matches beginning of string
#otherwise returns the emtpy string
def matchesFront(regex, string):
    rexp = re.compile(regex)
    m = rexp.match(string)
    if m:
        return m.group()
    else:
        return ''

#useful for testing tokenize with map(...)
def getAttrib(token):
    return token.attrib

def getID(token):
    return token.ID

#### PARSER FUNCTIONS ############################################################

#TODO: this is all a bit messy due to passing essentially a vector around
# instead of a list and not having shared state. Could be made a
# lot simpler by using shared state...

#vcalc context-free grammar
#line      -> directive | expr | assign
#directive -> decDir | octDir | hexDir | intDir | floatDir | statusDir | varDir | quitDir
#assign    -> let assign' | assign'
#assign'   ->  ident = expr | ident += expr | ident -= expr
#             | ident *= expr | ident /= expr | ident %= expr | ident **= expr
#expr      -> expr + term | expr - term | term
#func      -> ident ( args )
#args      -> expr , args | expr
#term      -> term * factor | term / factor | term % factor
#             | term << factor | term >> factor | term ! | factor
#factor    -> expt ** factor | expt
#expt      -> func | ident | - number | number | ( expr )
#number    -> decnumber | hexnumber | octalnumber

#vcalc context-free grammar LL(1) -- to be used with a recursive descent parser
#line       -> directive | assign | expr
#directive  -> decDir | octDir | hexDir | intDir | floatDir | statusDir | varDir | quitDir
#assign     -> [let] ident (=|+=|-=|*=|/=|%=|**=) expr
#expr       -> term {(+|-) term}
#func       -> ident ( args )
#args       -> expr {, expr}
#term       -> factor {(*|/|%|<<|>>) factor} [!]
#factor     -> {expt **} expt
#expt       -> func | ident | - number | number | ( expr )
#number     -> decnumber | hexnumber | octalnumber

class ParseNode(object):
    def __init__(self, success, result, consumedTokens):
        self._success = success
        self._result = result
        self._consumedTokens = consumedTokens
        self._storeInAns = True
        self._assignedSymbol = ''
    def getSuccess(self):
        return self._success
    def getResult(self):
        return self._result
    def getConsumed(self):
        return self._consumedTokens
    def getStoreInAns(self):
        return self._storeInAns
    def setStoreInAns(self, val):
        self._storeInAns = val
    def getAssignedSymbol(self):
        return self._assignedSymbol
    def setAssignedSymbol(self, val):
        self._assignedSymbol = val
    success = property(getSuccess,
                       doc='Successfully evaluated?')
    result = property(getResult,
                      doc='The evaluated result at this node.')
    consumeCount = property(getConsumed,
                            doc='Number of consumed tokens.')
    storeInAns = property(getStoreInAns, setStoreInAns,
                          doc='Should store in ans variable?')
    assignedSymbol = property(getAssignedSymbol, setAssignedSymbol,
                              doc='Symbol expression assigned to.')

class ParseException(Exception):
    def __init__(self, message, consumedTokens):
        self._message = message
        self._consumed = consumedTokens
    def getMessage(self):
        return self._message
    def getConsumed(self):
        return self._consumed
    message = property(getMessage)
    consumed = property(getConsumed)

#recursive descent parser -- simple and befitting the needs of this small program
#generates the parse tree with evaluated decoration
def parse(expr):
    tokens = tokenize(expr)
    if symbolCheck('ERROR', 0, tokens):
        return 'Syntax error: ' + tokens[0].attrib
    try:
        lineNode = line(tokens)
        if lineNode.success:
            if lineNode.storeInAns:
                storeSymbol('ans', lineNode.result)
                return 'ans = ' + process(lineNode.result)
            else:
                if lineNode.assignedSymbol == None:
                    return str(lineNode.result)
                else:
                    return lineNode.assignedSymbol + ' = ' + process(lineNode.result)
        else:
            return 'Parse error: the expression is invalid.'
    except ParseException, pe:
        return 'Parse error: ' + pe.message

#this function returns an output string based on the global repl directives
def process(result):
    if VCALC_OUTPUT_BASE == 'decimal':
        output = result
    elif VCALC_OUTPUT_BASE == 'hexadecimal':
        return str(hex(int(result)))
    elif VCALC_OUTPUT_BASE == 'octal':
        return str(oct(int(result)))
    else:
        return 'ERROR'

    if VCALC_OUTPUT_PRECISION == 'int':
        return str(int(output))
    elif VCALC_OUTPUT_PRECISION == 'float':
        return str(output)
    else:
        return 'ERROR'


def line(tokens):
    directiveNode = directive(tokens)
    if directiveNode.success:
        if directiveNode.consumeCount == len(tokens):
            return directiveNode
        else:
            return ParseNode(False, 0, directiveNode.consumeCount)
    assignNode = assign(tokens)
    if assignNode.success:
        if assignNode.consumeCount == len(tokens):
            return assignNode
        else:
            return ParseNode(False, 0, assignNode.consumeCount)
    exprNode = expr(tokens)
    if exprNode.success:
        if exprNode.consumeCount == len(tokens):
            return exprNode
        else:
            return ParseNode(False, 0, exprNode.consumeCount)
    return ParseNode(False, 0, 0)

VCALC_OUTPUT_BASE      = 'decimal'
VCALC_OUTPUT_PRECISION = 'float'

def directive(tokens):
    #TODO: refactor this -- extract method
    global VCALC_OUTPUT_BASE
    global VCALC_OUTPUT_PRECISION
    if symbolCheck('decDir', 0, tokens):
        VCALC_OUTPUT_BASE = 'decimal'
        return createDirectiveParseNode('CHANGED OUTPUT BASE TO DECIMAL.')
    if symbolCheck('hexDir', 0, tokens):
        VCALC_OUTPUT_BASE = 'hexadecimal'
        return createDirectiveParseNode('CHANGED OUTPUT BASE TO HEXADECIMAL.')
    if symbolCheck('octDir', 0, tokens):
        VCALC_OUTPUT_BASE = 'octal'
        return createDirectiveParseNode('CHANGED OUTPUT BASE TO OCTAL.')
    if symbolCheck('floatDir', 0, tokens):
        VCALC_OUTPUT_PRECISION = 'float'
        return createDirectiveParseNode('CHANGED OUTPUT PRECISION TO FLOATING POINT.')
    if symbolCheck('intDir', 0, tokens):
        VCALC_OUTPUT_PRECISION = 'int'
        return createDirectiveParseNode('CHANGED OUTPUT PRECISION TO INTEGER.')
    if symbolCheck('statusDir', 0, tokens):
        return createDirectiveParseNode(statusMessage())
    if symbolCheck('varDir', 0, tokens):
        return createDirectiveParseNode(variablesMessage())
    if symbolCheck('quitDir', 0, tokens):
        return createDirectiveParseNode('!!!q!!!')
    return ParseNode(False, 0, 0)

def assign(tokens):
    if symbolCheck('ident', 0, tokens):
        assignPos = 1
    elif map(getID, tokens[0:2]) == ['let', 'ident']:
        assignPos = 2
    else:
        return ParseNode(False, 0, 0)

    exprNode = expr(tokens[assignPos+1:])
    if exprNode.consumeCount+assignPos+1 == len(tokens):
        symbol = tokens[assignPos-1].attrib

        #perform type of assignment
        if symbolCheck('assign', assignPos, tokens):
            result = exprNode.result
        else:
            result = lookupSymbol(symbol)
            if symbolCheck('pAssign', assignPos, tokens):
                result = result + exprNode.result
            elif symbolCheck('sAssign', assignPos, tokens):
                result = result - exprNode.result
            elif symbolCheck('mAssign', assignPos, tokens):
                result = result * exprNode.result
            elif symbolCheck('dAssign', assignPos, tokens):
                result = result / exprNode.result
            elif symbolCheck('modAssign', assignPos, tokens):
                result = result % exprNode.result
            elif symbolCheck('expAssign', assignPos, tokens):
                result = result ** exprNode.result
            else:
                return ParseNode(False,0,assignPos)

        storeSymbol(symbol, result)
        node = ParseNode(True, result, exprNode.consumeCount+assignPos+1)
        node.storeInAns = False
        node.assignedSymbol = symbol
        return node
    else:
        return ParseNode(False, 0, exprNode.consumeCount+assignPos+1)

def expr(tokens):
    termNode = term(tokens)
    consumed = termNode.consumeCount
    if termNode.success:
        foldNode = foldlParseMult(term,
                                  [lambda x,y:x+y, lambda x,y:x-y],
                                  ['plus','subtract'],
                                  termNode.result,
                                  tokens[consumed:])
        consumed += foldNode.consumeCount
        return ParseNode(foldNode.success, foldNode.result, consumed)
    else:
        return ParseNode(False, 0, consumed)

def func(tokens):
    if map(getID, tokens[0:2]) == ['ident', 'lParen']:
        sym = tokens[0].attrib
        argsNode = args(tokens[2:])
        if symbolCheck('rParen', argsNode.consumeCount+2, tokens):
            try:
                result = apply(lookupFunc(sym), argsNode.result)
                return ParseNode(True, result, argsNode.consumeCount+3)
            except TypeError, e:
                raise ParseException, (str(e), argsNode.consumeCount+3)
            except ValueError, e:
                raise ParseException, (str(e), argsNode.consumeCount+3)
        else:
            error = 'missing matching parenthesis for function ' + sym + '.'
            raise ParseException, (error, argsNode.consumeCount+2)
    else:
        return ParseNode(False, 0, 0)

def args(tokens):
    #returns a list of exprNodes to be used as function arguments
    exprNode = expr(tokens)
    consumed = exprNode.consumeCount
    if exprNode.success:
        foldNode = foldlParse(expr, snoc, 'comma', [exprNode.result], tokens[consumed:])
        return ParseNode(foldNode.success, foldNode.result, consumed+foldNode.consumeCount)
    else:
        return ParseNode(False, [], consumed)

def term(tokens):
    factNode = factor(tokens)
    consumed = factNode.consumeCount
    if factNode.success:
        foldNode = foldlParseMult(factor,
                                  [lambda x,y:x*y, lambda x,y:x/y, lambda x,y:x%y,
                                      lambda x,y:int(x)<<int(y), lambda x,y:int(x)>>int(y)],
                                  ['multiply', 'divide', 'modulo', 'lShift', 'rShift'],
                                  factNode.result,
                                  tokens[consumed:])
        consumed += foldNode.consumeCount
        if symbolCheck('factorial', consumed, tokens):
            return ParseNode(foldNode.success, factorial(foldNode.result), consumed+1)
        else:
            return ParseNode(foldNode.success, foldNode.result, consumed)
    else:
        return ParseNode(False, 0, consumed)

def factor(tokens):
    exptNode = expt(tokens)
    consumed = exptNode.consumeCount
    result = exptNode.result
    if exptNode.success:
        foldNode = foldrParse(expt, lambda x,y:x**y, 'exponent', result, tokens[consumed:])
        return ParseNode(foldNode.success, foldNode.result, consumed+foldNode.consumeCount)
    else:
        return ParseNode(False, 0, consumed)

def expt(tokens):
    #function
    funcNode = func(tokens)
    if funcNode.success:
        return funcNode
    #identifier
    if symbolCheck('ident', 0, tokens):
        return ParseNode(True, lookupSymbol(tokens[0].attrib), 1)
    #unary -
    if symbolCheck('subtract', 0, tokens):
        numberNode = number(tokens[1:])
        if numberNode.success:
            return ParseNode(True, numberNode.result*-1, numberNode.consumeCount+1)
    #plain number
    numberNode = number(tokens)
    if numberNode.success:
        return numberNode
    #(expr)
    if symbolCheck('lParen', 0, tokens):
        exprNode = expr(tokens[1:])
        if exprNode.success:
            if symbolCheck('rParen', exprNode.consumeCount+1, tokens):
                return ParseNode(True, exprNode.result, exprNode.consumeCount+2)
            else:
                error = 'missing matching parenthesis in expression.'
                raise ParseException, (error, exprNode.consumeCount+1)
    return ParseNode(False, 0, 0)

def number(tokens):
    if symbolCheck('decnumber', 0, tokens):
        if VCALC_OUTPUT_PRECISION == 'float':
            num = float(tokens[0].attrib)
        elif VCALC_OUTPUT_PRECISION == 'int':
            num = int(float(tokens[0].attrib)) #int from float as string input
        else:
            num = 0 #error
        return ParseNode(True, num, 1)
    elif symbolCheck('hexnumber', 0, tokens):
        return ParseNode(True, long(tokens[0].attrib,16), 1)
    elif symbolCheck('octnumber', 0, tokens):
        return ParseNode(True, long(tokens[0].attrib,8), 1)
    else:
        return ParseNode(False, 0, 0)

#### HELPER FUNCTIONS FOR USE BY THE PARSER AND REPL #############################

def foldlParse(parsefn, resfn, symbol, initial, tokens):
    consumed = 0
    result = initial
    if tokens == []:
        return ParseNode(True, result, consumed)
    else:
        while tokens[consumed].ID == symbol:
            parseNode = parsefn(tokens[consumed+1:])
            consumed += parseNode.consumeCount+1
            if parseNode.success:
                result = resfn(result, parseNode.result)
                if consumed >= len(tokens): return ParseNode(True,result,consumed)
            else:
                return ParseNode(False, 0, consumed)
        return ParseNode(True, result, consumed)

def foldlParseMult(parsefn, resfns, syms, initial, tokens):
    consumed = 0
    result = initial
    if tokens == []:
        return ParseNode(True, result, consumed)
    else:
        while tokens[consumed].ID in syms:
            sym = tokens[consumed].ID
            parseNode = foldlParse(parsefn, resfns[syms.index(sym)], sym, result, tokens[consumed:])
            if parseNode.success:
                result = parseNode.result
                consumed += parseNode.consumeCount
                if consumed >= len(tokens): return ParseNode(True,result,consumed)
            else:
                return ParseNode(False, 0, consumed)
        return ParseNode(True, result, consumed)

def foldrParse(parsefn, resfn, symbol, initial, tokens):
    #foldlParse into a sequence and then do a foldr to evaluate
    parseNode = foldlParse(parsefn, snoc, symbol, [], tokens)
    if parseNode.success:
        result = foldr(resfn, initial, parseNode.result)
        return ParseNode(parseNode.success, result, parseNode.consumeCount)
    else:
        return parseNode

def createDirectiveParseNode(outputMsg):
    node = ParseNode(True, outputMsg, 1)
    node.storeInAns = False
    node.assignedSymbol = None
    return node

def statusMessage():
    global VCALC_OUTPUT_BASE
    global VCALC_OUTPUT_PRECISION

    base = VCALC_OUTPUT_BASE.upper()
    if VCALC_OUTPUT_PRECISION   == 'float' : precision = 'FLOATING POINT'
    elif VCALC_OUTPUT_PRECISION == 'int'   : precision = 'INTEGER'
    else: VCALC_OUTPUT_PRECISION = 'ERROR'
    msg = "STATUS: OUTPUT BASE: %s; PRECISION: %s." % (base, precision)
    return msg

def variablesMessage():
    msg = "VARIABLES:\n----------\n"
    #find the longest variable length for alignment
    width = 0
    for k in VCALC_SYMBOL_TABLE.keys():
        width = max(width, len(k))

    items = VCALC_SYMBOL_TABLE.items()
    items.sort()
    for k,v in items:
        msg += " " + k.ljust(width) + " : " + process(v) + "\n"
    return msg

#rather literal haskell implementation of this, proably very
#unpythonic and inefficient. Should do for the needs of vimcalc
#however. TODO: in the future improve this!
def foldr(fn, init, lst):
    if lst == []:
        return init
    else:
        return fn(init, foldr(fn, lst[0], lst[1:]))

def symbolCheck(symbol, index, tokens):
    if index < len(tokens):
        if tokens[index].ID == symbol:
            return True
    return False

def snoc(seq, x):  #TODO: find more pythonic way of doing this
    a = seq
    a.append(x)
    return a

#### SYMBOL TABLE MANIPULATION FUNCTIONS #########################################

#global symbol table NOTE: these can be rebound
VCALC_SYMBOL_TABLE = {'ans':0,
                        'e':math.e,
                       'pi':math.pi,
                      'phi':1.6180339887498948482}

def lookupSymbol(symbol):
    if VCALC_SYMBOL_TABLE.has_key(symbol):
        return VCALC_SYMBOL_TABLE[symbol]
    else:
        error = "symbol '" + symbol + "' is not defined."
        raise ParseException, (error, 0)

def storeSymbol(symbol, value):
    VCALC_SYMBOL_TABLE[symbol] = value


#### VIMCALC BUILTIN FUNCTIONS ###################################################

def loge(n):
    return math.log(n)

def log2(n):
    return math.log(n, 2)

def nrt(x,y):
    return x**(1/y)

def factorial(n):
    acc = 1
    for i in xrange(int(n)):
        acc *= i+1
    return acc

def perms(n,k):
    return factorial(n)/factorial(n-k)

def choose(n,k):
    denominator = factorial(k) * factorial(n-k)
    return factorial(n)/denominator

#global built-in function table
#NOTE: variables do not share the same namespace as functions
#NOTE: if you change the name or add a function remember to update the syntax file

VCALC_FUNCTION_TABLE = {
        'abs'   : math.fabs,
        'acos'  : math.acos,
        'asin'  : math.asin,
        'atan'  : math.atan,
        'atan2' : math.atan2,
        'ceil'  : math.ceil,
        'choose': choose,
        'cos'   : math.cos,
        'cosh'  : math.cosh,
        'deg'   : math.degrees,
        'exp'   : math.exp,
        'floor' : math.floor,
        'hypot' : math.hypot,
        'inv'   : lambda n: 1/n,
        'ldexp' : math.ldexp,
        'lg'    : log2,
        'ln'    : loge,
        'log'   : math.log, #allows arbitrary base, defaults to e
        'log10' : math.log10,
        'max'   : max,
        'min'   : min,
        'nrt'   : nrt,
        'perms' : perms,
        'pow'   : math.pow,
        'rad'   : math.radians,
        'rand'  : random.random, #random() -> x in the interval [0, 1).
        'round' : round,
        'sin'   : math.sin,
        'sinh'  : math.sinh,
        'sqrt'  : math.sqrt,
        'tan'   : math.tan,
        'tanh'  : math.tanh
        }

def lookupFunc(symbol):
    if VCALC_FUNCTION_TABLE.has_key(symbol):
        return VCALC_FUNCTION_TABLE[symbol]
    else:
        error = "built-in function '" + symbol + "' does not exist."
        raise ParseException, (error, 0)
