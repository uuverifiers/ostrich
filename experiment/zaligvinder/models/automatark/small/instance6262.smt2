(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{5}-\d{3}|^\d{2}.\d{3}-\d{3}|\d{8})
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 8 8) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^(0|(-?(((0|[1-9]\d*)\.\d+)|([1-9]\d*))))$
(assert (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))) (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9")))))) (str.to_re "\u{0a}"))))
; ^[A-Z][a-z]+(o(i|u)(n|(v)?r(t)?|s|t|x)(e(s)?)?)$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}o") (re.union (str.to_re "i") (str.to_re "u")) (re.union (str.to_re "n") (re.++ (re.opt (str.to_re "v")) (str.to_re "r") (re.opt (str.to_re "t"))) (str.to_re "s") (str.to_re "t") (str.to_re "x")) (re.opt (re.++ (str.to_re "e") (re.opt (str.to_re "s"))))))))
; ([+(]?\d{0,2}[)]?)([-/.\s]?\d+)+
(assert (str.in_re X (re.++ (re.+ (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "+") (str.to_re "("))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (str.to_re ")")))))
(check-sat)
