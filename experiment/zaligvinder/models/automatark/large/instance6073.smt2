(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[a-z\d\u{2f}\u{2b}\u{3d}]{100}/AGPi
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 100 100) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "/") (str.to_re "+") (str.to_re "="))) (str.to_re "/AGPi\u{0a}"))))
; downloads\x2Emorpheus\x2Ecom\x2Frotation
(assert (not (str.in_re X (str.to_re "downloads.morpheus.com/rotation\u{0a}"))))
; /filename=[^\n]*\u{2e}addin/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".addin/i\u{0a}")))))
; ^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "A" "Z") (re.range "0" "9") (re.range "A" "Z") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
