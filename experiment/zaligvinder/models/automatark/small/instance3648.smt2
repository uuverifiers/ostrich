(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?([0-9]{1,3}[,]?)?([0-9]{3}[,]?)*[.]?[0-9]*$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([1-9]\d*|0)(([.,]\d*[1-9])?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (str.to_re "0")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) (re.* (re.range "0" "9")) (re.range "1" "9"))) (str.to_re "\u{0a}")))))
; /\u{2e}ppt([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.ppt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
