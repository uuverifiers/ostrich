(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; name.matches("a-z")
(assert (str.in_re X (re.++ (str.to_re "name") re.allchar (str.to_re "matches\u{22}a-z\u{22}\u{0a}"))))
; ^([0-9]{5})([\-]{1}[0-9]{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
