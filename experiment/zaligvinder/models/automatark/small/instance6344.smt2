(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/lists\/\d{20}$/U
(assert (str.in_re X (re.++ (str.to_re "//lists/") ((_ re.loop 20 20) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; /\u{2e}ppsx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ppsx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
