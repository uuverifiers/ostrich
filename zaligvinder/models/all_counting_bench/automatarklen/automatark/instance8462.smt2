(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\?a=dw[a-z]$/U
(assert (str.in_re X (re.++ (str.to_re "/?a=dw") (re.range "a" "z") (str.to_re "/U\u{0a}"))))
; ^([0-9]{4})-([0-1][0-9])-([0-3][0-9])\s([0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "--") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9")))))
; /\u{2e}m4b([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.m4b") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /filename=[^\n]*\u{2e}hhk/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hhk/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
