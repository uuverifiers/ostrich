(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(Op(.|us))(\s)[1-9](\d)*((,)?(\s)N(o.|um(.|ber))\s[1-9](\d)*)?$
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "1" "9") (re.* (re.range "0" "9")) (re.opt (re.++ (re.opt (str.to_re ",")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "N") (re.union (re.++ (str.to_re "o") re.allchar) (re.++ (str.to_re "um") (re.union re.allchar (str.to_re "ber")))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "1" "9") (re.* (re.range "0" "9")))) (str.to_re "\u{0a}Op") (re.union re.allchar (str.to_re "us")))))
; Uin=encodernotification\x2Ftoolbar\x2FHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "Uin=encodernotification\u{13}/toolbar/Host:User-Agent:\u{0a}"))))
; \x2FGR\s+\x2APORT3\x2A\d+Host\x3A
(assert (str.in_re X (re.++ (str.to_re "/GR") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "*PORT3*") (re.+ (re.range "0" "9")) (str.to_re "Host:\u{0a}"))))
; \+353\(0\)\s\d\s\d{3}\s\d{4}
(assert (str.in_re X (re.++ (str.to_re "+353(0)") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\x2Elookster\x2Enetnotificationuuid=qisezhin\u{2f}iqor\.ym
(assert (not (str.in_re X (str.to_re "www.lookster.netnotification\u{13}uuid=qisezhin/iqor.ym\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
