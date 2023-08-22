(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-z0-9]+[@]{1}[a-zA-Z]+[.]{1}[a-zA-Z]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; ^(net.tcp\://|(ht|f)tp(s?)\://)\S+
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "net") re.allchar (str.to_re "tcp://")) (re.++ (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")) (str.to_re "://"))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}")))))
; SecureNet\sHost\x3AX-Mailer\x3Aas\x2Estarware\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SecureNet") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:X-Mailer:\u{13}as.starware.com\u{0a}")))))
; (< *balise[ *>|:(.|\n)*>| (.|\n)*>](.|\n)*</balise *>)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}<") (re.* (str.to_re " ")) (str.to_re "balise") (re.union (str.to_re " ") (str.to_re "*") (str.to_re ">") (str.to_re "|") (str.to_re ":") (str.to_re "(") (str.to_re ".") (str.to_re "\u{0a}") (str.to_re ")")) (re.* (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "</balise") (re.* (str.to_re " ")) (str.to_re ">")))))
; .*[a-zA-Z]$
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
