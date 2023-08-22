(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\.\s]{3,}$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; (^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)
(assert (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
