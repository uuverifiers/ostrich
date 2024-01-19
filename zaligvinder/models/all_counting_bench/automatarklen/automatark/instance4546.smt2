(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http://www.mail-password-recovery.com/
(assert (not (str.in_re X (re.++ (str.to_re "http://www") re.allchar (str.to_re "mail-password-recovery") re.allchar (str.to_re "com/\u{0a}")))))
; ^(((\d{1,3})(,\d{3})*)|(\d+))(.\d+)?$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))) (re.opt (re.++ re.allchar (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\u{2e}webm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.webm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
