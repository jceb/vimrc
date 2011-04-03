import unittest
import vimcalc
import math

class SanityCheckTestCase(unittest.TestCase):
    def runTest(self):
        assert vimcalc.parse("5*4") == "ans = 20.0", 'sanity check.'

class OperatorTestCase(unittest.TestCase):
    def testAddition(self):
        assert vimcalc.parse("5+4") == "ans = 9.0", 'addition'

    def testSubtraction(self):
        assert vimcalc.parse("5-4") == "ans = 1.0", 'subtraction'

    def testMultiplication(self):
        assert vimcalc.parse("5*4") == "ans = 20.0", 'multiplication'

    def testDivision(self):
        assert vimcalc.parse("5/4") == "ans = 1.25", 'division'

    def testModulo(self):
        assert vimcalc.parse("5%4") == "ans = 1.0", 'modulo'
        assert vimcalc.parse("4%5") == "ans = 4.0", 'modulo'

    def testExponent(self):
        assert vimcalc.parse("5**4") == "ans = 625.0", 'exponent'

    def testLeftShift(self):
        assert vimcalc.parse("16<<1") == "ans = 32", 'left shift'
        assert vimcalc.parse("16<<2") == "ans = 64", 'left shift'

    def testRightShift(self):
        assert vimcalc.parse("16>>1") == "ans = 8", 'right shift'
        assert vimcalc.parse("16>>2") == "ans = 4", 'right shift'

    def testFactorial(self):
        assert vimcalc.parse("5!") == "ans = 120", 'factorial'

    def testComplicatedNested(self):
        assert vimcalc.parse("sin(sqrt(((pi/2)*2)**2)/2-(3-3))") == "ans = 1.0"

class OperatorPrecedenceTestCase(unittest.TestCase):
    #this could do with being better in every way.
    def testAllPrecedenceAtOnce(self):
        assert vimcalc.parse("5*4+2/sin(pi/2)**2+-1") == "ans = 21.0"

class OperatorAssociativityTestCase(unittest.TestCase):
    def testMultiplication(self):
        assert vimcalc.parse("2*2*2")   == "ans = 8.0"
        assert vimcalc.parse("(2*2)*2") == "ans = 8.0"
        assert vimcalc.parse("2*(2*2)") == "ans = 8.0"

    def testDivision(self):
        assert vimcalc.parse("(2/2)/3") == "ans = 0.333333333333"
        assert vimcalc.parse("2/(2/3)") == "ans = 3.0"
        assert vimcalc.parse("2/2/3")   == "ans = 0.333333333333"

    def testModulo(self):
        assert vimcalc.parse("(5%4)%3") == "ans = 1.0"
        assert vimcalc.parse("5%(4%3)") == "ans = 0.0"
        assert vimcalc.parse("5%4%3")   == "ans = 1.0"

    def testLeftShift(self):
        assert vimcalc.parse("(8<<1)<<2") == "ans = 64"
        assert vimcalc.parse("8<<(1<<2)") == "ans = 128"
        assert vimcalc.parse("8<<1<<2")   == "ans = 64"

    def testRightShift(self):
        assert vimcalc.parse("(16>>2)>>1") == "ans = 2"
        assert vimcalc.parse("16>>(2>>1)") == "ans = 8"
        assert vimcalc.parse("16>>1>>2")   == "ans = 2"

    def testFactorial(self):
        assert vimcalc.parse("5!!")   == "Parse error: the expression is invalid."
        assert vimcalc.parse("(3!)!") == "ans = 720"

    def testAddition(self):
        assert vimcalc.parse("(2+3)+4") == "ans = 9.0"
        assert vimcalc.parse("2+(3+4)") == "ans = 9.0"
        assert vimcalc.parse("2+3+4")   == "ans = 9.0"

    def testSubtraction(self):
        assert vimcalc.parse("4-3-2")   == "ans = -1.0"
        assert vimcalc.parse("(4-3)-2") == "ans = -1.0"
        assert vimcalc.parse("4-(3-2)") == "ans = 3.0"

    #right-to-left
    def testExponent(self):
        assert vimcalc.parse("(2**2)**3") == "ans = 64.0"
        assert vimcalc.parse("2**(2**3)") == "ans = 256.0"
        assert vimcalc.parse("2**2**3")   == "ans = 256.0"

class AssignmentTestCase(unittest.TestCase):
    def testAssign(self):
        assert vimcalc.parse("let x = 2")   == "x = 2.0", 'test assign.'
        assert vimcalc.parse("let x = 2.0") == "x = 2.0", 'test assign.'

    def testAssignNoLet(self):
        assert vimcalc.parse("x = 2")   == "x = 2.0", 'test assign.'
        assert vimcalc.parse("x = 2.0") == "x = 2.0", 'test assign.'

    def testUsingAssigned(self):
        vimcalc.parse("let a = 2")
        vimcalc.parse("let b = 8")
        vimcalc.parse("x = 2")
        vimcalc.parse("y = 8")
        assert vimcalc.parse("a + b") == "ans = 10.0", 'test using assignment'
        assert vimcalc.parse("x + 2") == "ans = 4.0", 'test using assignment'
        assert vimcalc.parse("x + y") == "ans = 10.0", 'test using assignment'

    def testAssignUsingAssigned(self):
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let z = x * y") == "z = 20.0", 'test assign assigned.'

    def testPAssign(self):
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let x += y") == "x = 9.0"

    def testSAssign(self):
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let y -= x") == "y = 1.0"

    def testMAssign(self):
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let x *= y") == "x = 20.0"

    def testDAssign(self):
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let x /= y") == "x = 0.8"

    def testModAssign(self):
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let x %= y") == "x = 4.0"
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let y %= x") == "y = 1.0"

    def testExpAssign(self):
        vimcalc.parse("x = 4")
        vimcalc.parse("y = 5")
        assert vimcalc.parse("let x **= y") == "x = 1024.0"

class ConstantsTestCase(unittest.TestCase):
    def testConstants(self):
        assert vimcalc.parse("e")   == "ans = 2.71828182846"
        assert vimcalc.parse("pi")  == "ans = 3.14159265359"
        assert vimcalc.parse("phi") == "ans = 1.61803398875"

class BasesTestCase(unittest.TestCase):
    def tearDown(self):
        vimcalc.parse(":dec")

    def testDecimal(self):
        assert vimcalc.parse(":dec") == "CHANGED OUTPUT BASE TO DECIMAL."
        assert vimcalc.parse("10")   == "ans = 10.0"
        assert vimcalc.parse("0x10") == "ans = 16"
        assert vimcalc.parse("010")  == "ans = 8"

    def testHexadecimal(self):
        assert vimcalc.parse(":hex") == "CHANGED OUTPUT BASE TO HEXADECIMAL."
        assert vimcalc.parse("10")   == "ans = 0xa"
        assert vimcalc.parse("0x10") == "ans = 0x10"
        assert vimcalc.parse("010")  == "ans = 0x8"

    def testOctal(self):
        assert vimcalc.parse(":oct") == "CHANGED OUTPUT BASE TO OCTAL."
        assert vimcalc.parse("10")   == "ans = 012"
        assert vimcalc.parse("0x10") == "ans = 020"
        assert vimcalc.parse("010")  == "ans = 010"

class PrecisionTestCase(unittest.TestCase):
    def tearDown(self):
        vimcalc.parse(":float")

    def testInteger(self):
        assert vimcalc.parse(":int") == "CHANGED OUTPUT PRECISION TO INTEGER."
        assert vimcalc.parse("(8/3) * (4/3)") == "ans = 2"

    def testFloat(self):
        assert vimcalc.parse(":float") == "CHANGED OUTPUT PRECISION TO FLOATING POINT."
        assert vimcalc.parse("(8/3) * (4/3)") == "ans = 3.55555555556"

class VarListingTestCase(unittest.TestCase):
    def setUp(self):
        self.resetSymbolTable()

    def tearDown(self):
        vimcalc.parse(":float")
        vimcalc.parse(":dec")

    def resetSymbolTable(self):
        temp = { 'ans' : 0,
                 'e'   : vimcalc.VCALC_SYMBOL_TABLE['e'],
                 'pi'  : vimcalc.VCALC_SYMBOL_TABLE['pi'],
                 'phi' : vimcalc.VCALC_SYMBOL_TABLE['phi'] }
        vimcalc.VCALC_SYMBOL_TABLE = temp

    def testSanity(self):
        assert len(vimcalc.VCALC_SYMBOL_TABLE)   == 4
        assert vimcalc.VCALC_SYMBOL_TABLE['ans'] == 0
        assert vimcalc.VCALC_SYMBOL_TABLE['e']   == math.e
        assert vimcalc.VCALC_SYMBOL_TABLE['pi']  == math.pi
        assert vimcalc.VCALC_SYMBOL_TABLE['phi'] == 1.6180339887498948482

    def testDefault(self):
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans : 0\n e   : 2.71828182846\n phi : 1.61803398875\n pi  : 3.14159265359\n"

    def testAddVars(self):
        #tests they get added and alphabetically
        assert vimcalc.parse("x = 2") == "x = 2.0"
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans : 0\n e   : 2.71828182846\n phi : 1.61803398875\n pi  : 3.14159265359\n x   : 2.0\n"
        assert vimcalc.parse("a = 2") == "a = 2.0"
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n a   : 2.0\n ans : 0\n e   : 2.71828182846\n phi : 1.61803398875\n pi  : 3.14159265359\n x   : 2.0\n"

    def testChangeMode(self):
        vimcalc.parse(":dec")
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans : 0\n e   : 2.71828182846\n phi : 1.61803398875\n pi  : 3.14159265359\n"
        vimcalc.parse(":hex")
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans : 0x0\n e   : 0x2\n phi : 0x1\n pi  : 0x3\n"
        vimcalc.parse(":oct")
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans : 0\n e   : 02\n phi : 01\n pi  : 03\n"

    def testChangePrecision(self):
        vimcalc.parse(":float")
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans : 0\n e   : 2.71828182846\n phi : 1.61803398875\n pi  : 3.14159265359\n"
        vimcalc.parse(":int")
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans : 0\n e   : 2\n phi : 1\n pi  : 3\n"

    def testAlignment(self):
        assert vimcalc.parse("let reallyLongName = 2") == "reallyLongName = 2.0"
        assert vimcalc.parse(":vars") == "VARIABLES:\n----------\n ans            : 0\n e              : 2.71828182846\n phi            : 1.61803398875\n pi             : 3.14159265359\n reallyLongName : 2.0\n"

class MiscDirectivesTestCase(unittest.TestCase):
    def setUp(self):
        vimcalc.parse(":dec")
        vimcalc.parse(":float")

    def tearDown(self):
        vimcalc.parse(":dec")
        vimcalc.parse(":float")

    def testStatusSanity(self):
        assert vimcalc.parse(":status") != "Syntax error: :status"

    def testStatus(self):
        assert vimcalc.parse(":status") == "STATUS: OUTPUT BASE: DECIMAL; PRECISION: FLOATING POINT."
        vimcalc.parse(":hex")
        assert vimcalc.parse(":status") == "STATUS: OUTPUT BASE: HEXADECIMAL; PRECISION: FLOATING POINT."
        vimcalc.parse(":oct")
        assert vimcalc.parse(":status") == "STATUS: OUTPUT BASE: OCTAL; PRECISION: FLOATING POINT."
        vimcalc.parse(":int")
        vimcalc.parse(":dec")
        assert vimcalc.parse(":status") == "STATUS: OUTPUT BASE: DECIMAL; PRECISION: INTEGER."
        vimcalc.parse(":hex")
        assert vimcalc.parse(":status") == "STATUS: OUTPUT BASE: HEXADECIMAL; PRECISION: INTEGER."
        vimcalc.parse(":oct")
        assert vimcalc.parse(":status") == "STATUS: OUTPUT BASE: OCTAL; PRECISION: INTEGER."

    def testStatusShorthand(self):
        assert vimcalc.parse(":s") == "STATUS: OUTPUT BASE: DECIMAL; PRECISION: FLOATING POINT."
        vimcalc.parse(":hex")
        assert vimcalc.parse(":s") == "STATUS: OUTPUT BASE: HEXADECIMAL; PRECISION: FLOATING POINT."
        vimcalc.parse(":oct")
        assert vimcalc.parse(":s") == "STATUS: OUTPUT BASE: OCTAL; PRECISION: FLOATING POINT."
        vimcalc.parse(":int")
        vimcalc.parse(":dec")
        assert vimcalc.parse(":s") == "STATUS: OUTPUT BASE: DECIMAL; PRECISION: INTEGER."
        vimcalc.parse(":hex")
        assert vimcalc.parse(":s") == "STATUS: OUTPUT BASE: HEXADECIMAL; PRECISION: INTEGER."
        vimcalc.parse(":oct")
        assert vimcalc.parse(":s") == "STATUS: OUTPUT BASE: OCTAL; PRECISION: INTEGER."

    def testQuitDirective(self):
        assert vimcalc.parse(":q") == "!!!q!!!"

class ErrorMessagesTestCase(unittest.TestCase):
    def testNonExistantBuiltin(self):
        assert vimcalc.parse("foo()") == "Parse error: built-in function 'foo' does not exist."

    def testUnmatchedParens(self):
        assert vimcalc.parse("(5")   == "Parse error: missing matching parenthesis in expression."
        assert vimcalc.parse("((5)") == "Parse error: missing matching parenthesis in expression."
        assert vimcalc.parse("(()")  == "Parse error: the expression is invalid."

    def testUndefinedSymbol(self):
        assert vimcalc.parse("thisshouldnotexist") == "Parse error: symbol 'thisshouldnotexist' is not defined."

    def testSyntaxError(self):
        assert vimcalc.parse("\"string\"") == "Syntax error: \"string\""
        assert vimcalc.parse("'string'")   == "Syntax error: 'string'"

    def testParseError(self):
        assert vimcalc.parse("9**5/)")  == "Parse error: the expression is invalid."
        assert vimcalc.parse("4//5")    == "Parse error: the expression is invalid."
        assert vimcalc.parse("--1")     == "Parse error: the expression is invalid."
        assert vimcalc.parse("!4")      == "Parse error: the expression is invalid."
        assert vimcalc.parse("2***3")   == "Parse error: the expression is invalid."
        assert vimcalc.parse("sin(2,)") == "Parse error: apply() arg 2 expected sequence, found int"

class FunctionsTestCase(unittest.TestCase):
    def testAbs(self):
        assert vimcalc.parse("abs(-4.2)")     == "ans = 4.2", 'test abs(x)'
    def testAcos(self):
        assert vimcalc.parse("acos(1)")       == "ans = 0.0", 'test acos(x)'
    def testAsin(self):
        assert vimcalc.parse("asin(0)")       == "ans = 0.0", 'test asin(x)'
    def testAtan(self):
        assert vimcalc.parse("atan(0)")       == "ans = 0.0", 'test atan(x)'
    def testAtan2(self):
        assert vimcalc.parse("atan2(1,1)")    == "ans = 0.785398163397", 'test atan2(y,x)'
    def testCeil(self):
        assert vimcalc.parse("ceil(4.2)")     == "ans = 5.0", 'test ceil(x)'
    def testChoose(self):
        assert vimcalc.parse("choose(3,2)")   == "ans = 3", 'test choose(n,k)'
        assert vimcalc.parse("choose(3,2.2)") == "ans = 3", 'test choose(n,k)'
    def testCos(self):
        assert vimcalc.parse("cos(0)")        == "ans = 1.0", 'test cos(x)'
    #TODO:
    def testCosh(self):
        assert vimcalc.parse("cosh(1)")       == "ans = 1.54308063482", 'test cosh(x)'
    def testDeg(self):
        assert vimcalc.parse("deg(pi)")       == "ans = 180.0", 'test deg(x)'
        assert vimcalc.parse("deg(pi/2)")     == "ans = 90.0", 'test deg(x)'
        assert vimcalc.parse("deg(2*pi)")     == "ans = 360.0", 'test deg(x)'
        assert vimcalc.parse("deg(2*pi+1)")   == "ans = 417.295779513", 'test deg(x)'
    def testExp(self):
        assert vimcalc.parse("exp(1)/e")      == "ans = 1.0", 'test exp(x)'
    def testFloor(self):
        assert vimcalc.parse("floor(4.7)")    == "ans = 4.0", 'test floor(x)'
    def testHypot(self):
        assert vimcalc.parse("hypot(3,4)")    == "ans = 5.0", 'test hypot(x,y)'
    def testInv(self):
        assert vimcalc.parse("inv(2)")        == "ans = 0.5", 'test inv(x)'
    #TODO:
    #def testLdexp(self):
        #assert vimcalc.parse("ldexp(2,2)")   == "ans = ", 'test ldexp(x,i)'
    def testLg(self):
        assert vimcalc.parse("lg(0)")         == "Parse error: math domain error", 'test lg(x)'
        assert vimcalc.parse("lg(1)")         == "ans = 0.0", 'test lg(x)'
        assert vimcalc.parse("lg(4)")         == "ans = 2.0", 'test lg(x)'
    def testLn(self):
        assert vimcalc.parse("ln(0)")         == "Parse error: math domain error", 'test ln(x)'
        assert vimcalc.parse("ln(1)")         == "ans = 0.0", 'test ln(x)'
        assert vimcalc.parse("ln(e)")         == "ans = 1.0", 'test ln(x)'
    def testLog(self):
        assert vimcalc.parse("log(9,3)")      == "ans = 2.0", 'test log(x,b)'
        assert vimcalc.parse("log(1,3)")      == "ans = 0.0", 'test log(x,b)'
        assert vimcalc.parse("log(0,3)")      == "Parse error: math domain error", 'test log(x,b)'
    def testLog10(self):
        assert vimcalc.parse("log10(100)")    == "ans = 2.0", 'test log10(x)'
        assert vimcalc.parse("log10(1)")      == "ans = 0.0", 'test log10(x)'
        assert vimcalc.parse("log10(0)")      == "Parse error: math domain error", 'test log10(x)'
    def testMax(self):
        assert vimcalc.parse("max(3,7)")      == "ans = 7.0", 'test max(x,y)'
        assert vimcalc.parse("max(3.2,7.6)")  == "ans = 7.6", 'test max(x,y)'
    def testMin(self):
        assert vimcalc.parse("min(3,7)")      == "ans = 3.0", 'test min(x,y)'
        assert vimcalc.parse("min(3.2,7.6)")  == "ans = 3.2", 'test min(x,y)'
    def testNrt(self):
        assert vimcalc.parse("nrt(27,3)")     == "ans = 3.0", 'test nrt(x,n)'
    def testPerms(self):
        assert vimcalc.parse("perms(3,2)")    == "ans = 6", 'test perms(n,k)'
    def testPow(self):
        assert vimcalc.parse("pow(2,5)")      == "ans = 32.0", 'test pow(x,y)'
    def testRad(self):
        assert vimcalc.parse("rad(0)")        == "ans = 0.0", 'test rad(x)'
        assert vimcalc.parse("rad(180)")      == "ans = 3.14159265359", 'test rad(x)'
        assert vimcalc.parse("rad(360)")      == "ans = 6.28318530718", 'test rad(x)'
    #def testRand(self):
        #assert vimcalc.parse("rand()")       == "ans = ", 'test rand()'
    def testRound(self):
        assert vimcalc.parse("round(4.2)")    == "ans = 4.0", 'test round(x)'
        assert vimcalc.parse("round(4.7)")    == "ans = 5.0", 'test round(x)'
    def testSin(self):
        assert vimcalc.parse("sin(pi/2)")     == "ans = 1.0", 'test sin.'
        assert vimcalc.parse("sin(0)")        == "ans = 0.0", 'test sin.'
    #TODO:
    def testSinh(self):
        assert vimcalc.parse("sinh(0)")       == "ans = 0.0", 'test sinh(x)'
    def testSqrt(self):
        assert vimcalc.parse("sqrt(64)")      == "ans = 8.0", 'test sqrt(x)'
        assert vimcalc.parse("sqrt(0)")       == "ans = 0.0", 'test sqrt(x)'
        assert vimcalc.parse("sqrt(2)")       == "ans = 1.41421356237", 'test sqrt(x)'
    def testTan(self):
        assert vimcalc.parse("tan(0)")        == "ans = 0.0", 'test tan(x)'
    def testTanh(self):
        assert vimcalc.parse("tanh(0)")       == "ans = 0.0", 'test tanh(x)'

if __name__ == "__main__":
    unittest.main()
