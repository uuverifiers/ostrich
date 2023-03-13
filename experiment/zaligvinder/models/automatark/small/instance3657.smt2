(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}skm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.skm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^-?\d+([^.,])?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re ","))) (str.to_re "\u{0a}")))))
; ^[A-Z]$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (str.to_re "\u{0a}")))))
; ^(\d){8}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
