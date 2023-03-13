(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <.*\b(bgcolor\s*=\s*[\"|\']*(\#\w{6})[\"|\']*).*>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.* re.allchar) (re.* re.allchar) (str.to_re ">\u{0a}bgcolor") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "|") (str.to_re "'"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "|") (str.to_re "'"))) (str.to_re "#") ((_ re.loop 6 6) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; (^\([0]\d{1}\))(\d{7}$)|(^\([0][2]\d{1}\))(\d{6,8}$)|([0][8][0][0])([\s])(\d{5,8}$)
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "(0") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")")) (re.++ ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "(02") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")")) (re.++ (str.to_re "0800") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
