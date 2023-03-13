(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(BG){0,1}([0-9]{9}|[0-9]{10})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "BG")) (re.union ((_ re.loop 9 9) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; OSSProxy\d+X-Mailer\x3Abacktrust\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "OSSProxy") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer:\u{13}backtrust.com\u{0a}")))))
; /filename\=[a-z0-9]{24}\.jar/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/H\u{0a}")))))
; User-Agent\x3A\x2FrssMinutesansweras\x2Estarware\x2EcomFictionalHost\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:/rssMinutesansweras.starware.comFictionalHost:Host:\u{0a}"))))
; ^(9,)*([1-9]\d{2}-?)*[1-9]\d{2}-?\d{4}$
(assert (str.in_re X (re.++ (re.* (str.to_re "9,")) (re.* (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")))) (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
