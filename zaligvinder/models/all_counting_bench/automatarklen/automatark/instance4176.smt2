(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; forum=.*Explorer\s+Host\x3Aact=Host\u{3a}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "forum=") (re.* re.allchar) (str.to_re "Explorer") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:act=Host:User-Agent:\u{0a}")))))
; ^(\d{1,8}|(\d{0,8}\.{1}\d{1,2}){1})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 8) (re.range "0" "9")) ((_ re.loop 1 1) (re.++ ((_ re.loop 0 8) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
