(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (FR-?)?[0-9A-Z]{2}\ ?[0-9]{9}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "FR") (re.opt (str.to_re "-")))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.opt (str.to_re " ")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; GmbH\d+Host\x3A\w+adblock\x2Elinkz\x2EcomUser-Agent\x3Aemail
(assert (str.in_re X (re.++ (str.to_re "GmbH") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "adblock.linkz.comUser-Agent:email\u{0a}"))))
; toolbar_domain_redirectlibManager\x2Edll\x5Eget
(assert (not (str.in_re X (str.to_re "toolbar_domain_redirectlibManager.dll^get\u{0a}"))))
; ^((((19|20)(([02468][048])|([13579][26])).02.29))|((20[0-9][0-9])|(19[0-9][0-9])).((((0[1-9])|(1[0-2])).((0[1-9])|(1[0-9])|(2[0-8])))|((((0[13578])|(1[02])).31)|(((0[1,3-9])|(1[0-2])).(29|30)))))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")))) re.allchar (str.to_re "02") re.allchar (str.to_re "29")) (re.++ (re.union (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9"))) re.allchar (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) re.allchar (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8")))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) re.allchar (str.to_re "31")) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ",") (re.range "3" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) re.allchar (re.union (str.to_re "29") (str.to_re "30")))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
