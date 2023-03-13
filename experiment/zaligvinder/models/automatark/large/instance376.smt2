(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; spyblpatHost\x3Ais\x2EphpBarFrom\x3AHost\x3Agdvsotuqwsg\u{2f}dxt\.hd
(assert (str.in_re X (str.to_re "spyblpatHost:is.phpBarFrom:Host:gdvsotuqwsg/dxt.hd\u{0a}")))
; ^[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^\W{0,5}[Rr]e:\W[a-zA-Z0-9]{1,10},\W[a-z]{1,10}\W[a-z]{1,10}\W[a-z]{1,10}
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.union (str.to_re "R") (str.to_re "r")) (str.to_re "e:") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ",") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 10) (re.range "a" "z")) (str.to_re "\u{0a}"))))
(check-sat)
