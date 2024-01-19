(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Subject\x3Alinkautomatici\x2EcomReferer\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "Subject:linkautomatici.comReferer:www.searchreslt.com\u{0a}")))
; <h([1-6])>([^<]*)</h([1-6])>
(assert (not (str.in_re X (re.++ (str.to_re "<h") (re.range "1" "6") (str.to_re ">") (re.* (re.comp (str.to_re "<"))) (str.to_re "</h") (re.range "1" "6") (str.to_re ">\u{0a}")))))
; ^([a-z0-9]{32})$
(assert (str.in_re X (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
