(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\W{0,5}[Rr]e:\W[a-zA-Z0-9]{1,10},\W[a-z]{1,10}\W[a-z]{1,10}\W[a-z]{1,10}
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "R") (str.to_re "r")) (str.to_re "e:") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ",") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (str.to_re "\u{0a}"))))
; wlpgskmv\u{2f}lwzo\.qv#www\x2Ekliksearch\x2Ecom
(assert (not (str.in_re X (str.to_re "wlpgskmv/lwzo.qv#www.kliksearch.com\u{0a}"))))
(check-sat)
