(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(3(([0-5][0-9]{0,2})|60))|([1-2][0-9]{2})|(^[1-9]$)|(^[1-9]{2}$)$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "3") (re.union (re.++ (re.range "0" "5") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "60"))) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9"))) (re.range "1" "9") (re.++ ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "\u{0a}"))))))
; \d{6}
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ContactHost\u{3a}Host\x3AFloodedFictionalUser-Agent\x3AHost\u{3a}
(assert (not (str.in_re X (str.to_re "ContactHost:Host:FloodedFictionalUser-Agent:Host:\u{0a}"))))
; alert\d+an.*Spyiz=e2give\.comrichfind\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "alert") (re.+ (re.range "0" "9")) (str.to_re "an") (re.* re.allchar) (str.to_re "Spyiz=e2give.comrichfind.com\u{0a}")))))
; offers\x2Ebullseye-network\x2Ecom[^\n\r]*this\dwww\x2Etrustedsearch\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "offers.bullseye-network.com") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "this") (re.range "0" "9") (str.to_re "www.trustedsearch.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
