(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}xps([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.xps") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^(([1-9]{1}(\d+)?)(\.\d+)?)|([0]\.(\d+)?([1-9]{1})(\d+)?)$
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) ((_ re.loop 1 1) (re.range "1" "9")) (re.opt (re.+ (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}0.") (re.opt (re.+ (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "1" "9")) (re.opt (re.+ (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
