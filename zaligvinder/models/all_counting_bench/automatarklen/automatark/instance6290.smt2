(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Yeah\!Host\x3AEnTrYwww\x2EZSearchResults\x2Ecom
(assert (not (str.in_re X (str.to_re "Yeah!Host:EnTrYwww.ZSearchResults.com\u{13}\u{0a}"))))
; /filename=[^\n]*\u{2e}otf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".otf/i\u{0a}"))))
; [^a-zA-Z0-9]+
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /#([1-9]){2}([1-9]){2}([1-9]){2}/
(assert (str.in_re X (re.++ (str.to_re "/#") ((_ re.loop 2 2) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "/\u{0a}"))))
; ^0*(\d{1,3}(\.?\d{3})*)\-?([\dkK])$
(assert (str.in_re X (re.++ (re.* (str.to_re "0")) (re.opt (str.to_re "-")) (re.union (re.range "0" "9") (str.to_re "k") (str.to_re "K")) (str.to_re "\u{0a}") ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (re.opt (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
