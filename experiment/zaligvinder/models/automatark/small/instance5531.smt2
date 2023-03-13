(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}svgz?([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.svg") (re.opt (str.to_re "z")) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(http(s)?\:\/\/\S+)\s
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}http") (re.opt (str.to_re "s")) (str.to_re "://") (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))))
; /^POST\u{20}\u{2f}[A-F\d]{42}\u{20}HTTP/
(assert (str.in_re X (re.++ (str.to_re "/POST /") ((_ re.loop 42 42) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re " HTTP/\u{0a}"))))
; \.([A-Za-z0-9]{2,5}($|\b\?))
(assert (not (str.in_re X (re.++ (str.to_re ".\u{0a}") ((_ re.loop 2 5) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "?")))))
(check-sat)
