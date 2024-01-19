(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Pass-On\w+c\.goclick\.comletter
(assert (str.in_re X (re.++ (str.to_re "Pass-On") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "c.goclick.comletter\u{0a}"))))
; ^\$?\d+(\.(\d{2}))?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
