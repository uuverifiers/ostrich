(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\.{1}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ".")) (str.to_re "\u{0a}"))))
; ^((\(\d{3}\) ?)|(\d{3}-)|(\(\d{2}\) ?)|(\d{2}-)|(\(\d{1}\) ?)|(\d{1}-))?\d{3}-(\d{3}|\d{4})
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-")) (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-")) (re.++ (str.to_re "(") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-")))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Host\x3A\w+www.*ToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www") (re.* re.allchar) (str.to_re "ToolbartheServer:www.searchreslt.com\u{0a}")))))
; GmbH\d+Host\x3A\w+adblock\x2Elinkz\x2EcomUser-Agent\x3Aemail
(assert (str.in_re X (re.++ (str.to_re "GmbH") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "adblock.linkz.comUser-Agent:email\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
