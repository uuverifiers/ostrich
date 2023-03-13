(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{00}\.\u{00}\.\u{00}[\u{2f}\u{5c}]/R
(assert (not (str.in_re X (re.++ (str.to_re "/\u{00}.\u{00}.\u{00}") (re.union (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "/R\u{0a}")))))
; ^0[1-6]{1}(([0-9]{2}){4})|((\s[0-9]{2}){4})|((-[0-9]{2}){4})$
(assert (str.in_re X (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 4 4) ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 4 4) (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ ((_ re.loop 4 4) (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[a-z\.]*\s?([a-z\-\']+\s)+[a-z\-\']+$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (str.to_re "."))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "'"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.+ (re.union (re.range "a" "z") (str.to_re "-") (str.to_re "'"))) (str.to_re "\u{0a}")))))
; Ready\s+Client\s+MyBrowserHost\u{3a}securityon\x3AHost\x3ARedirector\u{22}ServerHost\x3AX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Ready") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Client") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "MyBrowserHost:securityon:Host:Redirector\u{22}ServerHost:X-Mailer:\u{13}\u{0a}")))))
(check-sat)
