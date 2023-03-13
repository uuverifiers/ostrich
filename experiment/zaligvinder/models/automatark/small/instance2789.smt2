(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\u{3a}.*Host\u{3a}.*\x2Fproducts\x2Fspyblocs\x2F\sinternalcyber@yahoo\x2EcomHeadersRedirection
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "/products/spyblocs/\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "internalcyber@yahoo.comHeadersRedirection\u{0a}")))))
; ^(([1..9])|(0[1..9])|(1\d)|(2\d)|(3[0..1])).((\d)|(0\d)|(1[0..2])).(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ".") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "1"))) (str.to_re "1") (str.to_re ".") (str.to_re "9")) re.allchar (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "2")))) re.allchar ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; search\.dropspam\.com.*SupportFiles.*Referer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "search.dropspam.com") (re.* re.allchar) (str.to_re "SupportFiles\u{13}") (re.* re.allchar) (str.to_re "Referer:\u{0a}")))))
(check-sat)
