(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}htc/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".htc/i\u{0a}"))))
; /\u{2e}jpg([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jpg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (\$\s*[\d,]+\.\d{2})\b
(assert (str.in_re X (re.++ (str.to_re "\u{0a}$") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (str.to_re ","))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))))
; ^\d*[1-9]\d*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.range "1" "9") (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
