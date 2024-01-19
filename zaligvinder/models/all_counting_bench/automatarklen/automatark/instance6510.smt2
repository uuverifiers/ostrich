(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Za-z]{2}[ ]{0,1}[0-9]{2}[ ]{0,1}[a-zA-Z]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; User-Agent\x3A\s+information\swww\x2Etopadwarereviews\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "information") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.topadwarereviews.com\u{0a}")))))
; body=\u{25}21\u{25}21\u{25}21Optix\s+Host\u{3a}
(assert (str.in_re X (re.++ (str.to_re "body=%21%21%21Optix\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; @([_a-zA-Z]+)
(assert (not (str.in_re X (re.++ (str.to_re "@") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; ^[a-zA-Z0-9]{1,20}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
