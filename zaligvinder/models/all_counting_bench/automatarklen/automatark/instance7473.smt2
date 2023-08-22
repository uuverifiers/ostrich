(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d+$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}s3m([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.s3m") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; (\{\\f\d*)\\([^;]+;)
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}\u{0a}{\u{5c}f") (re.* (re.range "0" "9")) (re.+ (re.comp (str.to_re ";"))) (str.to_re ";")))))
; /\x3F[0-9a-z]{32}D/U
(assert (not (str.in_re X (re.++ (str.to_re "/?") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "D/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
