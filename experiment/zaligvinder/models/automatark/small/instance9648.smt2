(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\w+www\x2Etopadwarereviews\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www.topadwarereviews.com\u{0a}")))))
; /filename=[^\n]*\u{2e}csv/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".csv/i\u{0a}")))))
; ^[a-zA-Z]$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; CZ\d{2}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}[ ]\d{4}|CZ\d{22}
(assert (str.in_re X (re.++ (str.to_re "CZ") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 22 22) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ([oO0]*)([|:;=X^])([-']*)([)(oO0\]\[DPp*>X^@])
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "o") (str.to_re "O") (str.to_re "0"))) (re.union (str.to_re "|") (str.to_re ":") (str.to_re ";") (str.to_re "=") (str.to_re "X") (str.to_re "^")) (re.* (re.union (str.to_re "-") (str.to_re "'"))) (re.union (str.to_re ")") (str.to_re "(") (str.to_re "o") (str.to_re "O") (str.to_re "0") (str.to_re "]") (str.to_re "[") (str.to_re "D") (str.to_re "P") (str.to_re "p") (str.to_re "*") (str.to_re ">") (str.to_re "X") (str.to_re "^") (str.to_re "@")) (str.to_re "\u{0a}")))))
(check-sat)
