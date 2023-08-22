(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{5}\x2D\d{3}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")))))
; <.*\b(bgcolor\s*=\s*[\"|\']*(\#\w{6})[\"|\']*).*>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* re.allchar) (re.* re.allchar) (str.to_re ">\u{0a}bgcolor") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "|") (str.to_re "'"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "|") (str.to_re "'"))) (str.to_re "#") ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; ^([0-7]{3})$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "7")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
