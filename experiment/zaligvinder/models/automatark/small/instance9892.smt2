(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; TROJAN-Owner\x3AUser-Agent\u{3a}%3fTs2\x2F
(assert (str.in_re X (str.to_re "TROJAN-Owner:User-Agent:%3fTs2/\u{0a}")))
; ^[\d]{5}[-\s]{1}[\d]{3}[-\s]{1}[\d]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\/app\/\?prj=\d\u{26}pid=[^\r\n]+\u{26}mac=/Ui
(assert (str.in_re X (re.++ (str.to_re "//app/?prj=") (re.range "0" "9") (str.to_re "&pid=") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "&mac=/Ui\u{0a}"))))
; ^\w+.*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar) (str.to_re "\u{0a}"))))
(check-sat)
