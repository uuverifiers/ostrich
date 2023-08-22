(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [+-]?(0|[1-9]([0-9]{0,2})(,[0-9]{3})*)(\.[0-9]+)?
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
