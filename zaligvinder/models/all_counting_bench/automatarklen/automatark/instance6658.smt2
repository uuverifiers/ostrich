(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(1[0-2]|0?[1-9]):([0-5]?[0-9])( AM| PM)$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (str.to_re ":\u{0a}") (re.opt (re.range "0" "5")) (re.range "0" "9") (str.to_re " ") (re.union (str.to_re "AM") (str.to_re "PM")))))
; ^((\(0?[1-9][0-9]\))|(0?[1-9][0-9]))[ -.]?([1-9][0-9]{3})[ -.]?([0-9]{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "0")) (re.range "1" "9") (re.range "0" "9") (str.to_re ")")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9") (re.range "0" "9"))) (re.opt (re.range " " ".")) (re.opt (re.range " " ".")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}") (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))))))
; /\u{2e}wps([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.wps") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
