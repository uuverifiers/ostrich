(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d+,?\d+\$?
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ",")) (re.+ (re.range "0" "9")) (re.opt (str.to_re "$")) (str.to_re "\u{0a}")))))
; /^\/[a-f0-9]{32}\/[a-f0-9]{32}\.swf$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".swf/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
