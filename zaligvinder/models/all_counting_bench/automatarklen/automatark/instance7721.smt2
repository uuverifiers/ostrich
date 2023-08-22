(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{4}\.html\?i\=\d{6,7}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?i=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; /\u{2e}wmf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wmf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^([1-9]+[0-9]*|\d*[.,]\d)$
(assert (str.in_re X (re.++ (re.union (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (re.union (str.to_re ".") (str.to_re ",")) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
