(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /&key=[a-z0-9]{32}&dummy=\d{3,5}/Ui
(assert (str.in_re X (re.++ (str.to_re "/&key=") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "&dummy=") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; TPSystemHost\u{3a}\x7D\x7BUser\x3AAlert\x2Fcgi-bin\x2FX-Mailer\x3A
(assert (not (str.in_re X (str.to_re "TPSystemHost:}{User:Alert/cgi-bin/X-Mailer:\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
