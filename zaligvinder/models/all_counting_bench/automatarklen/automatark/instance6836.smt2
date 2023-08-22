(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; TM_SEARCH3Host\u{3a}User-Agent\x3Amedia\x2Edxcdirect\x2Ecom
(assert (not (str.in_re X (str.to_re "TM_SEARCH3Host:User-Agent:media.dxcdirect.com\u{0a}"))))
; ^(([0-9]{2})|([a-zA-Z][0-9])|([a-zA-Z]{2}))[0-9]{6}$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(\d{5}-\d{4}|\d{5}|\d{9})$|^([a-zA-Z]\d[a-zA-Z]( )?\d[a-zA-Z]\d)$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.opt (str.to_re " ")) (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 9 9) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
