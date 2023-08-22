(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}rt([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.rt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Host\x3AX-Mailer\u{3a}toolbar\.wishbone\.com
(assert (not (str.in_re X (str.to_re "Host:X-Mailer:\u{13}toolbar.wishbone.com\u{0a}"))))
; ^100(\.0{0,2}?)?$|^\d{0,2}(\.\d{0,2})?$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (str.to_re "0"))))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
