(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename\=[a-z0-9]{24}\.jar/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/H\u{0a}")))))
; ^[-+]?[0-9]+[.]?[0-9]*([eE][-+]?[0-9]+)?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (^[0-9]{0,10}$)
(assert (not (str.in_re X (re.++ ((_ re.loop 0 10) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
