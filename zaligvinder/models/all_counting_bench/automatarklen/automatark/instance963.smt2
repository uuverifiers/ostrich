(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; HXLogOnly\w+Host\x3AspasHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "HXLogOnly") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:spasHost:\u{0a}")))))
; ^(([0-9]{3})[-]?)*[0-9]{6,7}$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")))) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
