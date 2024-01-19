(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1..9])|(0[1..9])|(1\d)|(2\d)|(3[0..1])).((\d)|(0\d)|(1[0..2])).(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ".") (str.to_re "9"))) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "1"))) (str.to_re "1") (str.to_re ".") (str.to_re "9")) re.allchar (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re ".") (str.to_re "2")))) re.allchar ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}class([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.class") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[0-9]*[1-9]+[0-9]*$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Subject\x3A.*User-Agent\x3A.*ResultATTENTION\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.* re.allchar) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "ResultATTENTION:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
