(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SecureNet\sHost\x3AX-Mailer\x3Aas\x2Estarware\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "SecureNet") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:X-Mailer:\u{13}as.starware.com\u{0a}"))))
; (^[a-zA-Z0-9]+://)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "://")))))
; Subject\x3ALOGX-Mailer\u{3a}
(assert (str.in_re X (str.to_re "Subject:LOGX-Mailer:\u{13}\u{0a}")))
; ((079)|(078)|(077)){1}[0-9]{7}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "079") (str.to_re "078") (str.to_re "077"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; wjpropqmlpohj\u{2f}lo\d+Host\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "wjpropqmlpohj/lo") (re.+ (re.range "0" "9")) (str.to_re "Host:User-Agent:\u{0a}"))))
(check-sat)
