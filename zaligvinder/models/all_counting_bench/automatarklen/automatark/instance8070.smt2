(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}.*ver\dRobert\dDmInf\x5EinfoSimpsonUser-Agent\x3AClientwww\x2Einternet-optimizer\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "ver") (re.range "0" "9") (str.to_re "Robert") (re.range "0" "9") (str.to_re "DmInf^infoSimpsonUser-Agent:Clientwww.internet-optimizer.com\u{0a}"))))
; on\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "on") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}")))))
; iz=Referer\x3Aoffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "iz=Referer:offers.bullseye-network.com\u{0a}"))))
; (^(\d{2}.\d{3}.\d{3}/\d{4}-\d{2})|(\d{14})$)
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) re.allchar ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 14 14) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}skm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".skm/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
