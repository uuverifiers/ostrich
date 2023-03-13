(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; IPUSER-Host\x3AUser-Agent\x3A\x2Fsearchfast\x2F
(assert (not (str.in_re X (str.to_re "IPUSER-Host:User-Agent:/searchfast/\u{0a}"))))
; \x2Fbar_pl\x2Fchk\.fcgiHost\u{3a}
(assert (str.in_re X (str.to_re "/bar_pl/chk.fcgiHost:\u{0a}")))
; /\/setup\/[a-z0-9!-]{50}/Ui
(assert (str.in_re X (re.++ (str.to_re "//setup/") ((_ re.loop 50 50) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "!") (str.to_re "-"))) (str.to_re "/Ui\u{0a}"))))
(check-sat)
