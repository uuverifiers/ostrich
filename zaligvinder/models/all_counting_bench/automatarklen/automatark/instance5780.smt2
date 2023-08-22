(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-f0-9]{32}\/\d{10}\/[a-f0-9]{32}\.jar$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".jar/Ui\u{0a}")))))
; ^[+-]? *100(\.0{0,2})? *%?$|^[+-]? *\d{1,2}(\.\d{1,2})? *%?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (str.to_re "0")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%"))) (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; ad\x2Emokead\x2Ecom\d+Spy\d+ZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlinkwww\x2Epurityscan\x2EcomUser-Agent\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "ad.mokead.com") (re.+ (re.range "0" "9")) (str.to_re "Spy") (re.+ (re.range "0" "9")) (str.to_re "ZOMBIES_HTTP_GETearch.earthlinkwww.purityscan.comUser-Agent:\u{0a}")))))
; ^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((\d{8})|(\d{10})|(\d{11})|(\d{6}-\d{5}))?$
(assert (not (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 11 11) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
