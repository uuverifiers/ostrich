(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.php\?[a-z]{2,8}=[a-z0-9]{2}\u{3a}[a-z0-9]{2}\u{3a}[a-z0-9]{2}\u{3a}[a-z0-9]{2}\u{3a}[a-z0-9]{2}\&[a-z]{2,8}=/U
(assert (str.in_re X (re.++ (str.to_re "/.php?") ((_ re.loop 2 8) (re.range "a" "z")) (str.to_re "=") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "&") ((_ re.loop 2 8) (re.range "a" "z")) (str.to_re "=/U\u{0a}"))))
(check-sat)
