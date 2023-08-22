(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]+(\.[a-zA-Z]+)+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; (((0[123456789]|10|11|12)(([1][9][0-9][0-9])|([2][0-9][0-9][0-9]))))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (str.to_re "10") (str.to_re "11") (str.to_re "12")) (re.union (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9")))))))
; version.*Host\u{3a}\s+iWonHost\u{3a}pjpoptwql\u{2f}rlnj
(assert (str.in_re X (re.++ (str.to_re "version") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "iWonHost:pjpoptwql/rlnj\u{0a}"))))
; ^[A-Z]{3}-[0-9]{4}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3AlogUser-Agent\x3AonSubject\x3A
(assert (not (str.in_re X (str.to_re "Host:logUser-Agent:onSubject:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
