(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d{2,4})/)?((\d{6,8})|(\d{2})-(\d{2})-(\d{2,4})|(\d{3,4})-(\d{3,4}))$
(assert (not (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "/"))) (re.union ((_ re.loop 6 8) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 4) (re.range "0" "9"))) (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /\/loader\.cpl$/U
(assert (str.in_re X (str.to_re "//loader.cpl/U\u{0a}")))
; ^(([A-Z]{1}[a-z]+([\-][A-Z]{1}[a-z]+)?)([ ]([A-Z]\.)){0,2}[ ](([A-Z]{1}[a-z]*)|([O]{1}[\']{1}[A-Z][a-z]{2,}))([ ](Jr\.|Sr\.|IV|III|II))?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 2) (re.++ (str.to_re " ") (re.range "A" "Z") (str.to_re "."))) (str.to_re " ") (re.union (re.++ ((_ re.loop 1 1) (re.range "A" "Z")) (re.* (re.range "a" "z"))) (re.++ ((_ re.loop 1 1) (str.to_re "O")) ((_ re.loop 1 1) (str.to_re "'")) (re.range "A" "Z") ((_ re.loop 2 2) (re.range "a" "z")) (re.* (re.range "a" "z")))) (re.opt (re.++ (str.to_re " ") (re.union (str.to_re "Jr.") (str.to_re "Sr.") (str.to_re "IV") (str.to_re "III") (str.to_re "II")))) ((_ re.loop 1 1) (re.range "A" "Z")) (re.+ (re.range "a" "z")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "A" "Z")) (re.+ (re.range "a" "z")))))))
(check-sat)
