(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]+(\.[a-zA-Z]+)+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}sum/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sum/i\u{0a}"))))
; /[^\u{0d}\u{0a}\u{09}\u{20}-\u{7e}]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "\u{09}") (re.range " " "~"))) (str.to_re "/P\u{0a}"))))
; logs\s+TCP.*Toolbarads\.grokads\.com
(assert (not (str.in_re X (re.++ (str.to_re "logs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "TCP") (re.* re.allchar) (str.to_re "Toolbarads.grokads.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
