(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[a-z]{5,8}\d{2,3}\.xap\u{0d}\u{0a}/Hm
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".xap\u{0d}\u{0a}/Hm\u{0a}")))))
; (\d*)'*-*(\d*)/*(\d*)"
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (str.to_re "'")) (re.* (str.to_re "-")) (re.* (re.range "0" "9")) (re.* (str.to_re "/")) (re.* (re.range "0" "9")) (str.to_re "\u{22}\u{0a}")))))
; .*[a-zA-Z]$
(assert (not (str.in_re X (re.++ (re.* re.allchar) (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}plp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plp/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
