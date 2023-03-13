(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{2}-[0-9]{8}-[0-9]$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; GmbH\d+Host\x3A\w+adblock\x2Elinkz\x2EcomUser-Agent\x3Aemail
(assert (not (str.in_re X (re.++ (str.to_re "GmbH") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "adblock.linkz.comUser-Agent:email\u{0a}")))))
; SPY\s\x5BStaticHost\x3AFROM\x3Acs\x2Eshopperreports\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "SPY") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "[StaticHost:FROM:cs.shopperreports.com\u{0a}")))))
; /\/[a-z]{2}\/testcon.php$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "/testcon") re.allchar (str.to_re "php/U\u{0a}")))))
; ^[^\"]+$
(assert (str.in_re X (re.++ (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{0a}"))))
(check-sat)
