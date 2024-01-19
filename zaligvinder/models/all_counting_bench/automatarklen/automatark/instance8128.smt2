(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; spyblpatHost\x3Ais\x2EphpBarFrom\x3AHost\x3Agdvsotuqwsg\u{2f}dxt\.hd
(assert (not (str.in_re X (str.to_re "spyblpatHost:is.phpBarFrom:Host:gdvsotuqwsg/dxt.hd\u{0a}"))))
; ^([a-zA-Z0-9]+([\.+_-][a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+((\.|[-]{1,2})[a-zA-Z0-9]+)*)\.[a-zA-Z]{2,6})$
(assert (not (str.in_re X (re.++ (str.to_re "@\u{0a}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (re.union (str.to_re ".") (str.to_re "+") (str.to_re "_") (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (re.union (str.to_re ".") ((_ re.loop 1 2) (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))))))))
(assert (> (str.len X) 10))
(check-sat)
