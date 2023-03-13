(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/f\/1\d{9}\/\d{9,10}(\/\d)+$/U
(assert (str.in_re X (re.++ (str.to_re "//f/1") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 9 10) (re.range "0" "9")) (re.+ (re.++ (str.to_re "/") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; /filename=[^\n]*\u{2e}ogx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ogx/i\u{0a}")))))
; [a-zA-Z0-9]*
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
