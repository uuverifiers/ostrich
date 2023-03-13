(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}f4p([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.f4p") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /\x2Faws\d{1,5}\.jsp\x3F/i
(assert (str.in_re X (re.++ (str.to_re "//aws") ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".jsp?/i\u{0a}"))))
; e(vi?)?
(assert (not (str.in_re X (re.++ (str.to_re "e") (re.opt (re.++ (str.to_re "v") (re.opt (str.to_re "i")))) (str.to_re "\u{0a}")))))
(check-sat)
