(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax
(assert (str.in_re X (str.to_re "\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax\u{0a}")))
; quick\x2Eqsrch\x2Ecom\s+Apofis\d+ToolBar
(assert (not (str.in_re X (re.++ (str.to_re "quick.qsrch.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Apofis") (re.+ (re.range "0" "9")) (str.to_re "ToolBar\u{0a}")))))
; /[^&]+&[a-z]=[a-f0-9]{16}&[a-z]=[a-f0-9]{16}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; ^\d{1,2}\/\d{2,4}$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^images.php\?t=\d{2,7}$/U
(assert (str.in_re X (re.++ (str.to_re "/images") re.allchar (str.to_re "php?t=") ((_ re.loop 2 7) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
