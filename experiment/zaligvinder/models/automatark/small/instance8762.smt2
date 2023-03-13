(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^.{2,}$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) re.allchar) (re.* re.allchar))))
; /^\/ABs[A-Za-z0-9]+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//ABs") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; ^[a-z][a-z0-9\.,\-_]{5,31}$
(assert (not (str.in_re X (re.++ (re.range "a" "z") ((_ re.loop 5 31) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ".") (str.to_re ",") (str.to_re "-") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(check-sat)
