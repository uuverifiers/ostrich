(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; HXLogOnly\w+Host\x3AspasHost\x3A
(assert (str.in_re X (re.++ (str.to_re "HXLogOnly") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:spasHost:\u{0a}"))))
; (^\d{1,3}([,]\d{3})*$)|(^\d{1,16}$)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 16) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
