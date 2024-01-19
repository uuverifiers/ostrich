(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\([2-9]\d{2}\)[ ]?)|([2-9]\d{2})[- ]?)\d{3}[- ]?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ([^\.\?\!]*)[\.\?\!]
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re ".") (str.to_re "?") (str.to_re "!"))) (re.union (str.to_re ".") (str.to_re "?") (str.to_re "!")) (str.to_re "\u{0a}"))))
; Subject\u{3a}reportGatorNavExcel
(assert (str.in_re X (str.to_re "Subject:reportGatorNavExcel\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
