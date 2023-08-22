(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ( xmlns:.*=[",'].*[",'])|( xmlns=[",'].*[",'])
(assert (str.in_re X (re.union (re.++ (str.to_re " xmlns:") (re.* re.allchar) (str.to_re "=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'"))) (re.++ (str.to_re "\u{0a} xmlns=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'"))))))
; upgrade\x2Eqsrch\x2Einfox2Fie\.aspdcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (str.to_re "upgrade.qsrch.infox2Fie.aspdcww.dmcast.com\u{0a}"))))
; ^((2[0-5][0-5]|1[\d][\d]|[\d][\d]|[\d])\.){3}(2[0-5][0-5]|1[\d][\d]|[\d][\d]|[\d])$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (str.to_re "2") (re.range "0" "5") (re.range "0" "5")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "."))) (re.union (re.++ (str.to_re "2") (re.range "0" "5") (re.range "0" "5")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^3[234689][0-9]$
(assert (not (str.in_re X (re.++ (str.to_re "3") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "8") (str.to_re "9")) (re.range "0" "9") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
