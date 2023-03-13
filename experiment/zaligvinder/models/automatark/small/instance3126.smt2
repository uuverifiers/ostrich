(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0]?[1-9]|[1][0-2]|[2][0-3]):([0-5][0-9]|[1-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.union (re.++ (re.range "0" "5") (re.range "0" "9")) (re.range "1" "9")) (str.to_re "\u{0a}"))))
; ^\d{1,2}((,)|(,25)|(,50)|(,5)|(,75)|(,0)|(,00))?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (str.to_re ",") (str.to_re ",25") (str.to_re ",50") (str.to_re ",5") (str.to_re ",75") (str.to_re ",0") (str.to_re ",00"))) (str.to_re "\u{0a}")))))
; ZC-Bridge\s+www\x2Ewebcruiser\x2Ecc\u{22}StealthReferer\x3AContact
(assert (str.in_re X (re.++ (str.to_re "ZC-Bridge") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.webcruiser.cc\u{22}StealthReferer:Contact\u{0a}"))))
(check-sat)
