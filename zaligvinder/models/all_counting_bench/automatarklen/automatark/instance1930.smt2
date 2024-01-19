(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\+){1}[1-9]{1}[0-9]{0,1}[0-9]{0,1}(\s){1}[\(]{1}[1-9]{1}[0-9]{1,5}[\)]{1}[\s]{1})[1-9]{1}[0-9]{4,9}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 4 9) (re.range "0" "9")) (str.to_re "\u{0a}") ((_ re.loop 1 1) (str.to_re "+")) ((_ re.loop 1 1) (re.range "1" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 5) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ")")) ((_ re.loop 1 1) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; href[ ]*=[ ]*('|\")([^\"'])*('|\")
(assert (str.in_re X (re.++ (str.to_re "href") (re.* (str.to_re " ")) (str.to_re "=") (re.* (str.to_re " ")) (re.union (str.to_re "'") (str.to_re "\u{22}")) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.union (str.to_re "'") (str.to_re "\u{22}")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
