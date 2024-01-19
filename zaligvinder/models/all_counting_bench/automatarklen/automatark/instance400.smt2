(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; AdTools\sdownloadfile\u{2e}org\w+com\x3E[^\n\r]*as\x2Estarware\x2EcomOS\x2FSSKCstech\x2Eweb-nexus\x2Enet
(assert (str.in_re X (re.++ (str.to_re "AdTools") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "downloadfile.org") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com>") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "as.starware.comOS/SSKCstech.web-nexus.net\u{0a}"))))
; ([A-HJ-PR-Y]{2}([0][1-9]|[1-9][0-9])|[A-HJ-PR-Y]{1}([1-9]|[1-2][0-9]|30|31|33|40|44|55|50|60|66|70|77|80|88|90|99|111|121|123|222|321|333|444|555|666|777|888|999|100|200|300|400|500|600|700|800|900))[ ][A-HJ-PR-Z]{3}$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")))) (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Y"))) (re.union (re.range "1" "9") (re.++ (re.range "1" "2") (re.range "0" "9")) (str.to_re "30") (str.to_re "31") (str.to_re "33") (str.to_re "40") (str.to_re "44") (str.to_re "55") (str.to_re "50") (str.to_re "60") (str.to_re "66") (str.to_re "70") (str.to_re "77") (str.to_re "80") (str.to_re "88") (str.to_re "90") (str.to_re "99") (str.to_re "111") (str.to_re "121") (str.to_re "123") (str.to_re "222") (str.to_re "321") (str.to_re "333") (str.to_re "444") (str.to_re "555") (str.to_re "666") (str.to_re "777") (str.to_re "888") (str.to_re "999") (str.to_re "100") (str.to_re "200") (str.to_re "300") (str.to_re "400") (str.to_re "500") (str.to_re "600") (str.to_re "700") (str.to_re "800") (str.to_re "900")))) (str.to_re " ") ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.range "J" "P") (re.range "R" "Z"))) (str.to_re "\u{0a}")))))
; Referer\x3A\s+HXDownload.*Referer\x3AGREATDripline
(assert (not (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HXDownload") (re.* re.allchar) (str.to_re "Referer:GREATDripline\u{0a}")))))
; ^(\$|)([1-9]+\d{0,2}(\,\d{3})*|([1-9]+\d*))(\.\d{2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.union (re.++ (re.+ (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; shprrprt-cs-Pre\x2Fta\x2FNEWS\x2F
(assert (not (str.in_re X (str.to_re "shprrprt-cs-\u{13}Pre/ta/NEWS/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
