(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}\dgpstool\u{2e}globaladserver\u{2e}comdesksearch\.dropspam\.com
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "gpstool.globaladserver.comdesksearch.dropspam.com\u{0a}")))))
; ^(BG){0,1}([0-9]{9}|[0-9]{10})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "BG")) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /_X(86|64)&a4=/P
(assert (not (str.in_re X (re.++ (str.to_re "/_X") (re.union (str.to_re "86") (str.to_re "64")) (str.to_re "&a4=/P\u{0a}")))))
; \x2APORT2\x2A\w+Host\u{3a}\s+jspIDENTIFYserverHOST\x3ASubject\x3Ai\-femdom\x2EcomUser-Agent\x3Alog\=\x7BIP\x3A
(assert (not (str.in_re X (re.++ (str.to_re "*PORT2*") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "jspIDENTIFYserverHOST:Subject:i-femdom.comUser-Agent:log={IP:\u{0a}")))))
; /IPHONE\d+.\d/sH
(assert (not (str.in_re X (re.++ (str.to_re "/IPHONE") (re.+ (re.range "0" "9")) re.allchar (re.range "0" "9") (str.to_re "/sH\u{0a}")))))
(check-sat)
