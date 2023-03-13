(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((20)[0-9]{2})-((0[1-9])|(1[0-2]))-((3[0-1])|([0-2][1-9]|([1-2][0-9])))\s((2[0-3])|[0-1][0-9]):[0-5][0-9]
(assert (str.in_re X (re.++ (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (re.range "0" "2") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (str.to_re "2") (re.range "0" "3")) (re.++ (re.range "0" "1") (re.range "0" "9"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re "\u{0a}20") ((_ re.loop 2 2) (re.range "0" "9")))))
; \x7D\x7BTrojan\x3A\w+by\w+dddlogin\x2Edudu\x2EcomSurveillanceIPOblivionhoroscope
(assert (not (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "by") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "dddlogin.dudu.comSurveillance\u{13}IPOblivionhoroscope\u{0a}")))))
; www\x2Eserverlogic3\x2Ecom
(assert (not (str.in_re X (str.to_re "www.serverlogic3.com\u{0a}"))))
; ^[B|K|T|P][A-Z][0-9]{4}$
(assert (str.in_re X (re.++ (re.union (str.to_re "B") (str.to_re "|") (str.to_re "K") (str.to_re "T") (str.to_re "P")) (re.range "A" "Z") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; phpinfo[^\n\r]*195\.225\.\dccecaedbebfcaf\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "phpinfo") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "195.225.") (re.range "0" "9") (str.to_re "ccecaedbebfcaf.com\u{0a}")))))
(check-sat)
