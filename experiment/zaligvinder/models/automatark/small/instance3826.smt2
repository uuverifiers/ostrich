(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-")))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; url=\d+Host\x3A.*backtrust\x2Ecomv\x2ELoginHost\u{3a}\x2Ffriendship\x2Femail_thank_you\?
(assert (str.in_re X (re.++ (str.to_re "url=") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "backtrust.comv.LoginHost:/friendship/email_thank_you?\u{0a}"))))
; (\b(10|11|12|13|14|15|16|17|18|19)[0-9]\b)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.range "0" "9") (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")))))
; [+-](^0.*)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "+") (str.to_re "-")) (str.to_re "\u{0a}0") (re.* re.allchar)))))
; /\u{2e}pls([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pls") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
