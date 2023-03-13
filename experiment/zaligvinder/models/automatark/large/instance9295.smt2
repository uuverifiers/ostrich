(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(\+?\-? *[0-9]+)([,0-9 ]*)([0-9 ])*$)|(^ *$)
(assert (not (str.in_re X (re.union (re.++ (re.* (re.union (str.to_re ",") (re.range "0" "9") (str.to_re " "))) (re.* (re.union (re.range "0" "9") (str.to_re " "))) (re.opt (str.to_re "+")) (re.opt (str.to_re "-")) (re.* (str.to_re " ")) (re.+ (re.range "0" "9"))) (re.++ (re.* (str.to_re " ")) (str.to_re "\u{0a}"))))))
; /^\u{2f}[a-z0-9]{51}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 51 51) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
(check-sat)
