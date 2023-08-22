(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}.*ver\dRobert\dDmInf\x5EinfoSimpsonUser-Agent\x3AClientwww\x2Einternet-optimizer\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "ver") (re.range "0" "9") (str.to_re "Robert") (re.range "0" "9") (str.to_re "DmInf^infoSimpsonUser-Agent:Clientwww.internet-optimizer.com\u{0a}")))))
; ^\d{5}(\-)(\d{3})?$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; User-Agent\u{3a}\s+sErver\s+-~-GREATHost\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "sErver") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-~-GREATHost:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
