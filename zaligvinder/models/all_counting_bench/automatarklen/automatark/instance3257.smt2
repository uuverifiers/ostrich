(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^/]+$
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "/"))) (str.to_re "\u{0a}")))))
; ^([A-Z]{0,3}?[0-9]{9}($[0-9]{0}|[A-Z]{1}))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 3) (re.range "A" "Z")) ((_ re.loop 9 9) (re.range "0" "9")) (re.union ((_ re.loop 0 0) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")))))))
; /\u{2e}skm([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.skm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
