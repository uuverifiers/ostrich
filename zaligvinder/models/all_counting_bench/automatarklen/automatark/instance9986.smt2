(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; encoder[^\n\r]*\.cfg\s+Host\x3AWeHost\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "encoder") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re ".cfg") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:WeHost:\u{0a}")))))
; Host\x3A\s+ulmxct\u{2f}mqoycWinSession\x2Fclient\x2F\x2APORT1\x2A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoycWinSession/client/*PORT1*\u{0a}"))))
; GmbH\x2FcommunicatortbHost\x3AUser-Agent\x3Aadblock\x2Elinkz\x2Ecom
(assert (not (str.in_re X (str.to_re "GmbH/communicatortbHost:User-Agent:adblock.linkz.com\u{0a}"))))
; ^([\+][0-9]{1,3}([ \.\-])?)?([\(]{1}[0-9]{3}[\)])?([0-9A-Z \.\-]{1,32})((x|ext|extension)?[0-9]{1,4}?)$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-"))))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")"))) ((_ re.loop 1 32) (re.union (re.range "0" "9") (re.range "A" "Z") (str.to_re " ") (str.to_re ".") (str.to_re "-"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "x") (str.to_re "ext") (str.to_re "extension"))) ((_ re.loop 1 4) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
