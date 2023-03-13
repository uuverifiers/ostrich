(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ".*?"|".*$|'.*?'|'.*$
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{22}") (re.* re.allchar)) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "'")) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "\u{0a}")))))
; DigExt.*\u{23}\u{23}\u{23}\u{23}
(assert (not (str.in_re X (re.++ (str.to_re "DigExt") (re.* re.allchar) (str.to_re "####\u{0a}")))))
; ^-?((([0-9]{1,3},)?([0-9]{3},)*?[0-9]{3})|([0-9]{1,3}))\.[0-9]*$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re ".") (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([0-1]?[0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re "::\u{0a}") (re.range "0" "5") (re.range "0" "9") (re.range "0" "5") (re.range "0" "9"))))
(check-sat)
