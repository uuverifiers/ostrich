(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; X-Mailer\x3Acom\u{18}\u{16}dcww\x2Edmcast\x2EcomHost\x3Adist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (str.to_re "X-Mailer:\u{13}com\u{18}\u{16}dcww.dmcast.comHost:dist.atlas-ia.com\u{0a}"))))
; Software\s+User-Agent\x3A.*FictionalUser-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Software") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "FictionalUser-Agent:User-Agent:\u{0a}")))))
; Host\x3A\s+Online100013Agentsvr\x5E\x5EMerlin
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online100013Agentsvr^^Merlin\u{13}\u{0a}"))))
; ^(\d{5}-\d{2}-\d{7})*$
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^(([a-zA-Z]{2})([0-9]{6}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
