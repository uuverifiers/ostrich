(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (<b>)([^<>]+)(</b>)
(assert (not (str.in_re X (re.++ (str.to_re "<b>") (re.+ (re.union (str.to_re "<") (str.to_re ">"))) (str.to_re "</b>\u{0a}")))))
; ^[A-Za-z]{2}[0-9]{6}[A-Za-z]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
