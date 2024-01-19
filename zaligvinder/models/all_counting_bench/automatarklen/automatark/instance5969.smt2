(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[D-d][K-k]-[1-9]{1}[0-9]{3}$
(assert (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; SbAts\d+dcww\x2Edmcast\x2EcomdistID=
(assert (not (str.in_re X (re.++ (str.to_re "SbAts") (re.+ (re.range "0" "9")) (str.to_re "dcww.dmcast.comdistID=\u{0a}")))))
; 3A\s+URLBlazeHost\x3Atrackhjhgquqssq\u{2f}pjm
(assert (str.in_re X (re.++ (str.to_re "3A") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "URLBlazeHost:trackhjhgquqssq/pjm\u{0a}"))))
; Referer\x3Adialupvpn\u{5f}pwdwww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "Referer:dialupvpn_pwdwww.searchreslt.com\u{0a}")))
; X-OSSproxy\u{3a}\dMicrosoft\x2APORT3\x2AProLive\+Version\+3A
(assert (str.in_re X (re.++ (str.to_re "X-OSSproxy:") (re.range "0" "9") (str.to_re "Microsoft*PORT3*ProLive+Version+3A\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
