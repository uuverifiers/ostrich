(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b[A-Z0-9]{5}\d{1}[01567]\d{1}([0][1-9]|[12][0-9]|[3][0-1])\d{1}[A-Z0-9]{3}[A-Z]{2}\b
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (str.to_re "0") (str.to_re "1") (str.to_re "5") (str.to_re "6") (str.to_re "7")) ((_ re.loop 1 1) (re.range "0" "9")) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; /\/([0-9][0-9a-z]{2}|[0-9a-z][0-9][0-9a-z]|[0-9a-z]{2}[0-9])\.jar$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.union (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "z")))) (re.++ (re.union (re.range "0" "9") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "0" "9") (re.range "a" "z"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "z"))) (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}")))))
; /\u{2e}pct([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pct") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /filename=[^\n]*\u{2e}plf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plf/i\u{0a}")))))
(check-sat)
