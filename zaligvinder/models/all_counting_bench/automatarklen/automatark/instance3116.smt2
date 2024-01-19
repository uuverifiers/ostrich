(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9]+
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \w*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /[a-f0-9]{32}=[a-f0-9]{32}/C
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/C\u{0a}"))))
; ^[1-9]+\d*\.\d{2}$
(assert (str.in_re X (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}3gp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".3gp/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
