(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([07][1-7]|1[0-6]|2[0-7]|[35][0-9]|[468][0-8]|9[0-589])-?\d{7}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "7")) (re.range "1" "7")) (re.++ (str.to_re "1") (re.range "0" "6")) (re.++ (str.to_re "2") (re.range "0" "7")) (re.++ (re.union (str.to_re "3") (str.to_re "5")) (re.range "0" "9")) (re.++ (re.union (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.range "0" "8")) (re.++ (str.to_re "9") (re.union (re.range "0" "5") (str.to_re "8") (str.to_re "9")))) (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^100$|^100.00$|^\d{0,2}(\.\d{1,2})? *%?$
(assert (str.in_re X (re.union (str.to_re "100") (re.++ (str.to_re "100") re.allchar (str.to_re "00")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; /\x2Esum([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.sum") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
