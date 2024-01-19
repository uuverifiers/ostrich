(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-z\s]{2,})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "a" "z") (re.range "A" "z") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; GREATDriplineisUser-Agent\x3Alogs===========\x3E
(assert (str.in_re X (str.to_re "GREATDriplineisUser-Agent:logs===========>\u{0a}")))
; ^((([1]\d{2})|(22[0-3])|([1-9]\d)|(2[01]\d)|[1-9]).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d).(([1]\d{2})|(2[0-4]\d)|(25[0-5])|([1-9]\d)|\d))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "22") (re.range "0" "3")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.range "1" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) re.allchar (re.union (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
