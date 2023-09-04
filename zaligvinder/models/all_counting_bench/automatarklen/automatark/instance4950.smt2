(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-\w'+*$^&%=~!?{}#|/`]{1}([-\w'+*$^&%=~!?{}#|`.]?[-\w'+*$^&%=~!?{}#|`]{1}){0,31}[-\w'+*$^&%=~!?{}#|`]?@(([a-zA-Z0-9]{1}([-a-zA-Z0-9]?[a-zA-Z0-9]{1}){0,31})\.{1})+([a-zA-Z]{2}|[a-zA-Z]{3}|[a-zA-Z]{4}|[a-zA-Z]{6}){1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re "'") (str.to_re "+") (str.to_re "*") (str.to_re "$") (str.to_re "^") (str.to_re "&") (str.to_re "%") (str.to_re "=") (str.to_re "~") (str.to_re "!") (str.to_re "?") (str.to_re "{") (str.to_re "}") (str.to_re "#") (str.to_re "|") (str.to_re "/") (str.to_re "`") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 0 31) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "'") (str.to_re "+") (str.to_re "*") (str.to_re "$") (str.to_re "^") (str.to_re "&") (str.to_re "%") (str.to_re "=") (str.to_re "~") (str.to_re "!") (str.to_re "?") (str.to_re "{") (str.to_re "}") (str.to_re "#") (str.to_re "|") (str.to_re "`") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re "'") (str.to_re "+") (str.to_re "*") (str.to_re "$") (str.to_re "^") (str.to_re "&") (str.to_re "%") (str.to_re "=") (str.to_re "~") (str.to_re "!") (str.to_re "?") (str.to_re "{") (str.to_re "}") (str.to_re "#") (str.to_re "|") (str.to_re "`") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.opt (re.union (str.to_re "-") (str.to_re "'") (str.to_re "+") (str.to_re "*") (str.to_re "$") (str.to_re "^") (str.to_re "&") (str.to_re "%") (str.to_re "=") (str.to_re "~") (str.to_re "!") (str.to_re "?") (str.to_re "{") (str.to_re "}") (str.to_re "#") (str.to_re "|") (str.to_re "`") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 0 31) (re.++ (re.opt (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))))) ((_ re.loop 1 1) (re.union ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; SpyAgent\d+nick_name=CIA-Test\d+url=http\x3AHANDY\x2FNFO\x2CRegistered
(assert (not (str.in_re X (re.++ (str.to_re "SpyAgent") (re.+ (re.range "0" "9")) (str.to_re "nick_name=CIA-Test") (re.+ (re.range "0" "9")) (str.to_re "url=http:\u{1b}HANDY/NFO,Registered\u{0a}")))))
; myInstance\.myMethod(.*)\(.*myParam.*\)
(assert (str.in_re X (re.++ (str.to_re "myInstance.myMethod") (re.* re.allchar) (str.to_re "(") (re.* re.allchar) (str.to_re "myParam") (re.* re.allchar) (str.to_re ")\u{0a}"))))
; (([A-HJ-PRSTW]|A[BDHR]|BCK|B[ADEFHK-ORSUW]|BRD|C[AEFHKLNOSTY]|D[AEHKORS]|F[DEHRY]|G[HKNRUWY]|H[HL]|I[EH]|INS|KY|L[AHIKLNORTY]|M[EHLNRT]|N[ENT]|OB|P[DEHLNTWZ]|R[NORXY]|S[ACDEHMNORSTUY]|SSS|T[HNOT]|UL|W[ADHIKNOTY]|YH)[1-9][0-9]{0,2})|([1-9][0-9]{0,2}([A-HJ-PRSTW]|A[BDHR]|BCK|B[ADEFHK-ORSUW]|BRD|C[AEFHKLNOSTY]|D[AEHKORS]|F[DEHRY]|G[HKNRUWY]|H[HL]|I[EH]|INS|KY|L[AHIKLNORTY]|M[EHLNRT]|N[ENT]|OB|P[DEHLNTWZ]|R[NORXY]|S[ACDEHMNORSTUY]|SSS|T[HNOT]|UL|W[ADHIKNOTY]|YH))
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "A") (re.union (str.to_re "B") (str.to_re "D") (str.to_re "H") (str.to_re "R"))) (str.to_re "BCK") (re.++ (str.to_re "B") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "E") (str.to_re "F") (str.to_re "H") (re.range "K" "O") (str.to_re "R") (str.to_re "S") (str.to_re "U") (str.to_re "W"))) (str.to_re "BRD") (re.++ (str.to_re "C") (re.union (str.to_re "A") (str.to_re "E") (str.to_re "F") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "N") (str.to_re "O") (str.to_re "S") (str.to_re "T") (str.to_re "Y"))) (re.++ (str.to_re "D") (re.union (str.to_re "A") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "O") (str.to_re "R") (str.to_re "S"))) (re.++ (str.to_re "F") (re.union (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "R") (str.to_re "Y"))) (re.++ (str.to_re "G") (re.union (str.to_re "H") (str.to_re "K") (str.to_re "N") (str.to_re "R") (str.to_re "U") (str.to_re "W") (str.to_re "Y"))) (re.++ (str.to_re "H") (re.union (str.to_re "H") (str.to_re "L"))) (re.++ (str.to_re "I") (re.union (str.to_re "E") (str.to_re "H"))) (str.to_re "INS") (str.to_re "KY") (re.++ (str.to_re "L") (re.union (str.to_re "A") (str.to_re "H") (str.to_re "I") (str.to_re "K") (str.to_re "L") (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "T") (str.to_re "Y"))) (re.++ (str.to_re "M") (re.union (str.to_re "E") (str.to_re "H") (str.to_re "L") (str.to_re "N") (str.to_re "R") (str.to_re "T"))) (re.++ (str.to_re "N") (re.union (str.to_re "E") (str.to_re "N") (str.to_re "T"))) (str.to_re "OB") (re.++ (str.to_re "P") (re.union (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "L") (str.to_re "N") (str.to_re "T") (str.to_re "W") (str.to_re "Z"))) (re.++ (str.to_re "R") (re.union (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "X") (str.to_re "Y"))) (re.++ (str.to_re "S") (re.union (str.to_re "A") (str.to_re "C") (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "Y"))) (str.to_re "SSS") (re.++ (str.to_re "T") (re.union (str.to_re "H") (str.to_re "N") (str.to_re "O") (str.to_re "T"))) (str.to_re "UL") (re.++ (str.to_re "W") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "H") (str.to_re "I") (str.to_re "K") (str.to_re "N") (str.to_re "O") (str.to_re "T") (str.to_re "Y"))) (str.to_re "YH") (re.range "A" "H") (re.range "J" "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W")) (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "A") (re.union (str.to_re "B") (str.to_re "D") (str.to_re "H") (str.to_re "R"))) (str.to_re "BCK") (re.++ (str.to_re "B") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "E") (str.to_re "F") (str.to_re "H") (re.range "K" "O") (str.to_re "R") (str.to_re "S") (str.to_re "U") (str.to_re "W"))) (str.to_re "BRD") (re.++ (str.to_re "C") (re.union (str.to_re "A") (str.to_re "E") (str.to_re "F") (str.to_re "H") (str.to_re "K") (str.to_re "L") (str.to_re "N") (str.to_re "O") (str.to_re "S") (str.to_re "T") (str.to_re "Y"))) (re.++ (str.to_re "D") (re.union (str.to_re "A") (str.to_re "E") (str.to_re "H") (str.to_re "K") (str.to_re "O") (str.to_re "R") (str.to_re "S"))) (re.++ (str.to_re "F") (re.union (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "R") (str.to_re "Y"))) (re.++ (str.to_re "G") (re.union (str.to_re "H") (str.to_re "K") (str.to_re "N") (str.to_re "R") (str.to_re "U") (str.to_re "W") (str.to_re "Y"))) (re.++ (str.to_re "H") (re.union (str.to_re "H") (str.to_re "L"))) (re.++ (str.to_re "I") (re.union (str.to_re "E") (str.to_re "H"))) (str.to_re "INS") (str.to_re "KY") (re.++ (str.to_re "L") (re.union (str.to_re "A") (str.to_re "H") (str.to_re "I") (str.to_re "K") (str.to_re "L") (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "T") (str.to_re "Y"))) (re.++ (str.to_re "M") (re.union (str.to_re "E") (str.to_re "H") (str.to_re "L") (str.to_re "N") (str.to_re "R") (str.to_re "T"))) (re.++ (str.to_re "N") (re.union (str.to_re "E") (str.to_re "N") (str.to_re "T"))) (str.to_re "OB") (re.++ (str.to_re "P") (re.union (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "L") (str.to_re "N") (str.to_re "T") (str.to_re "W") (str.to_re "Z"))) (re.++ (str.to_re "R") (re.union (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "X") (str.to_re "Y"))) (re.++ (str.to_re "S") (re.union (str.to_re "A") (str.to_re "C") (str.to_re "D") (str.to_re "E") (str.to_re "H") (str.to_re "M") (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "Y"))) (str.to_re "SSS") (re.++ (str.to_re "T") (re.union (str.to_re "H") (str.to_re "N") (str.to_re "O") (str.to_re "T"))) (str.to_re "UL") (re.++ (str.to_re "W") (re.union (str.to_re "A") (str.to_re "D") (str.to_re "H") (str.to_re "I") (str.to_re "K") (str.to_re "N") (str.to_re "O") (str.to_re "T") (str.to_re "Y"))) (str.to_re "YH") (re.range "A" "H") (re.range "J" "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "W")))))))
; /filename=[^\n]*\u{2e}sum/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sum/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)