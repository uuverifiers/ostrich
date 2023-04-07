(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(H(P|T|U|Y|Z)|N(A|B|C|D|F|G|H|J|K|L|M|N|O|R|S|T|U|W|X|Y|Z)|OV|S(C|D|E|G|H|J|K|M|N|O|P|R|S|T|U|W|X|Y|Z)|T(A|F|G|L|M|Q|R|V)){1}\d{4}(NE|NW|SE|SW)?$|((H(P|T|U|Y|Z)|N(A|B|C|D|F|G|H|J|K|L|M|N|O|R|S|T|U|W|X|Y|Z)|OV|S(C|D|E|G|H|J|K|M|N|O|P|R|S|T|U|W|X|Y|Z)|T(A|F|G|L|M|Q|R|V)){1}(\d{4}|\d{6}|\d{8}|\d{10}))$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 1) (re.union (re.++ (str.to_re "H") (re.union (str.to_re "P") (str.to_re "T") (str.to_re "U") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "N") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "D") (str.to_re "F") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (str.to_re "OV") (re.++ (str.to_re "S") (re.union (str.to_re "C") (str.to_re "D") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "M") (str.to_re "N") (str.to_re "O") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "T") (re.union (str.to_re "A") (str.to_re "F") (str.to_re "G") (str.to_re "L") (str.to_re "M") (str.to_re "Q") (str.to_re "R") (str.to_re "V"))))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "NE") (str.to_re "NW") (str.to_re "SE") (str.to_re "SW")))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.++ (str.to_re "H") (re.union (str.to_re "P") (str.to_re "T") (str.to_re "U") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "N") (re.union (str.to_re "A") (str.to_re "B") (str.to_re "C") (str.to_re "D") (str.to_re "F") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "L") (str.to_re "M") (str.to_re "N") (str.to_re "O") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (str.to_re "OV") (re.++ (str.to_re "S") (re.union (str.to_re "C") (str.to_re "D") (str.to_re "E") (str.to_re "G") (str.to_re "H") (str.to_re "J") (str.to_re "K") (str.to_re "M") (str.to_re "N") (str.to_re "O") (str.to_re "P") (str.to_re "R") (str.to_re "S") (str.to_re "T") (str.to_re "U") (str.to_re "W") (str.to_re "X") (str.to_re "Y") (str.to_re "Z"))) (re.++ (str.to_re "T") (re.union (str.to_re "A") (str.to_re "F") (str.to_re "G") (str.to_re "L") (str.to_re "M") (str.to_re "Q") (str.to_re "R") (str.to_re "V"))))) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9")))))))
; ((EE|EL|DE|PT)-?)?[0-9]{9}
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "EE") (str.to_re "EL") (str.to_re "DE") (str.to_re "PT")) (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)