(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+User-Agent\x3A.*v\x3BApofisToolbarUser
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "v;ApofisToolbarUser\u{0a}"))))
; ^[0-2]?[1-9]{1}$|^3{1}[01]{1}$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.range "0" "2")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.union (str.to_re "0") (str.to_re "1"))) (str.to_re "\u{0a}"))))))
(check-sat)
