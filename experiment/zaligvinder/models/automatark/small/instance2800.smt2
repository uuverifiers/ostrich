(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; name\u{3d}Emailbadurl\x2Egrandstreetinteractive\x2EcomHost\x3Astepwww\x2Ekornputers\x2Ecom
(assert (not (str.in_re X (str.to_re "name=Emailbadurl.grandstreetinteractive.comHost:stepwww.kornputers.com\u{0a}"))))
; /\r\n\r\nsession\u{3a}\d{1,7}$/
(assert (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}\u{0d}\u{0a}session:") ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
; Host\x3AHost\x3AX-Mailer\u{3a}
(assert (str.in_re X (str.to_re "Host:Host:X-Mailer:\u{13}\u{0a}")))
(check-sat)
