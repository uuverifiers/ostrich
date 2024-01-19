(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; PASSW=\s+\x2Fta\x2FNEWS\x2F.*loomcompany\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "PASSW=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/ta/NEWS/") (re.* re.allchar) (str.to_re "loomcompany.com\u{0a}"))))
; ^(3(([0-5][0-9]{0,2})|60))|([1-2][0-9]{2})|(^[1-9]$)|(^[1-9]{2}$)$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "3") (re.union (re.++ (re.range "0" "5") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "60"))) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9"))) (re.range "1" "9") (re.++ ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
