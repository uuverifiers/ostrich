(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[a-z\d\u{2f}\u{2b}\u{3d}]{100}/AGPi
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "/") (str.to_re "+") (str.to_re "="))) (str.to_re "/AGPi\u{0a}")))))
; \x2Fta\x2FNEWS\x2Fpassword\x3B1\x3BOptix
(assert (not (str.in_re X (str.to_re "/ta/NEWS/password;1;Optix\u{0a}"))))
; ([a-zA-Z1-9]*)\.(((a|A)(s|S)(p|P)(x|X))|((h|H)(T|t)(m|M)(l|L))|((h|H)(t|T)(M|m))|((a|A)(s|S)(p|P))|((t|T)(x|X)(T|x))|((m|M)(S|s)(P|p)(x|X))|((g|G)(i|I)(F|f))|((d|D)(o|O)(c|C)))
(assert (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "1" "9"))) (str.to_re ".") (re.union (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "x") (str.to_re "X"))) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.union (str.to_re "T") (str.to_re "t")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "l") (str.to_re "L"))) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.union (str.to_re "t") (str.to_re "T")) (re.union (str.to_re "M") (str.to_re "m"))) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "s") (str.to_re "S")) (re.union (str.to_re "p") (str.to_re "P"))) (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.union (str.to_re "x") (str.to_re "X")) (re.union (str.to_re "T") (str.to_re "x"))) (re.++ (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "S") (str.to_re "s")) (re.union (str.to_re "P") (str.to_re "p")) (re.union (str.to_re "x") (str.to_re "X"))) (re.++ (re.union (str.to_re "g") (str.to_re "G")) (re.union (str.to_re "i") (str.to_re "I")) (re.union (str.to_re "F") (str.to_re "f"))) (re.++ (re.union (str.to_re "d") (str.to_re "D")) (re.union (str.to_re "o") (str.to_re "O")) (re.union (str.to_re "c") (str.to_re "C")))) (str.to_re "\u{0a}"))))
; Toolbar.*www\x2Ewebcruiser\x2Ecc\w+www\x2Etopadwarereviews\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Toolbar") (re.* re.allchar) (str.to_re "www.webcruiser.cc") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.com\u{0a}"))))
; \u{22}The\s+e2give\.com\s+NETObserve
(assert (not (str.in_re X (re.++ (str.to_re "\u{22}The") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "NETObserve\u{0a}")))))
(check-sat)
