(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}fdf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fdf/i\u{0a}"))))
; /filename=[^\n]*\u{2e}cis/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cis/i\u{0a}")))))
; /filename=p50[a-z0-9]{9}[0-9]{12}\.pdf/H
(assert (str.in_re X (re.++ (str.to_re "/filename=p50") ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ".pdf/H\u{0a}"))))
; /setInterval\s*\u{28}[^\u{29}]+\u{2e}focus\u{28}\u{29}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/setInterval") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ")"))) (str.to_re ".focus()/smi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
