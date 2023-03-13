(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z][a-z]+((eir|(n|l)h)(a|o))$
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}") (re.union (str.to_re "eir") (re.++ (re.union (str.to_re "n") (str.to_re "l")) (str.to_re "h"))) (re.union (str.to_re "a") (str.to_re "o")))))
; media\x2Etop-banners\x2Ecom
(assert (str.in_re X (str.to_re "media.top-banners.com\u{0a}")))
; /filename=[^\n]*\u{2e}asx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".asx/i\u{0a}")))))
; ^[A-Z]{1,3}\d{6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "A" "Z")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
