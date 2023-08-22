(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\&k=\d+($|\&h=)/U
(assert (str.in_re X (re.++ (str.to_re "/&k=") (re.+ (re.range "0" "9")) (str.to_re "&h=/U\u{0a}"))))
; ^((29-02-(19|20)(([02468][048])|([13579][26])))|(31-((0[13578])|(1[02]))|(30-((0[13456789])|(1[0-2])))|(29-((0[13456789])|(1[0-2])))|(((0[1-9]|)|(1[0-9])|(2[0-8]))-((0[1-9])|(1[0-2])))-((19|20)[0-9][0-9])))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "29-02-") (re.union (str.to_re "19") (str.to_re "20")) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6"))))) (re.++ (str.to_re "31-") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2"))))) (re.++ (str.to_re "30-") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "2")))) (re.++ (str.to_re "29-") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "2")))) (re.++ (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8"))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re "19") (str.to_re "20")) (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; (\d{5}-\d{4}|\d{5})
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; TROJAN-Owner\x3AUser-Agent\u{3a}%3fTs2\x2F
(assert (str.in_re X (str.to_re "TROJAN-Owner:User-Agent:%3fTs2/\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
