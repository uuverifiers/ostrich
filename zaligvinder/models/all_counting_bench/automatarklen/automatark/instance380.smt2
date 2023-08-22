(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Cookie\u{3a}AppName\x2FGRSI\|Server\|Host\x3Aorigin\x3Dsidefind
(assert (str.in_re X (str.to_re "Cookie:AppName/GRSI|Server|\u{13}Host:origin=sidefind\u{0a}")))
; ^[89][0-9]{9}
(assert (str.in_re X (re.++ (re.union (str.to_re "8") (str.to_re "9")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; search\u{2e}imesh\u{2e}com\s+WatchDogupwww\.klikvipsearch\.com
(assert (str.in_re X (re.++ (str.to_re "search.imesh.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDogupwww.klikvipsearch.com\u{0a}"))))
; Searchdata2\.activshopper\.comdll\x3FproductsCUSTOMSAccwww\x2Elocators\x2Ecom
(assert (str.in_re X (str.to_re "Searchdata2.activshopper.comdll?productsCUSTOMSAccwww.locators.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
