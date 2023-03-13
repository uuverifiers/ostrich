(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^0[87][23467]((\d{7})|( |-)((\d{3}))( |-)(\d{4})|( |-)(\d{7})))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}0") (re.union (str.to_re "8") (str.to_re "7")) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7")) (re.union ((_ re.loop 7 7) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))))))))
; loomcompany\x2EcomBasedURLS\swww\.fast-finder\.com
(assert (str.in_re X (re.++ (str.to_re "loomcompany.comBasedURLS") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com\u{0a}"))))
; dll\x3Fbadurl\x2Egrandstreetinteractive\x2Ecom
(assert (str.in_re X (str.to_re "dll?badurl.grandstreetinteractive.com\u{0a}")))
; zmnjgmomgbdz\u{2f}zzmw\.gztwww3\.addfreestats\.comKeylogger
(assert (not (str.in_re X (str.to_re "zmnjgmomgbdz/zzmw.gztwww3.addfreestats.comKeylogger\u{0a}"))))
; /^SSID=[a-zA-Z\d]{43}\x3B\u{20}A=[0-3]$/C
(assert (str.in_re X (re.++ (str.to_re "/SSID=") ((_ re.loop 43 43) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "; A=") (re.range "0" "3") (str.to_re "/C\u{0a}"))))
(check-sat)
