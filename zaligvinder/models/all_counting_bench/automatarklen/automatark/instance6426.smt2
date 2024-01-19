(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d+(-\d+)*)+(,\d+(-\d+)*)*
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))))) (re.* (re.++ (str.to_re ",") (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re "-") (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; /\/[a-zA-Z0-9]{32}\.jar/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
