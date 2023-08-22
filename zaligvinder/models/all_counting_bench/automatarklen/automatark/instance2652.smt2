(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \stoolbar\.anwb\.nl\s+A-311\s+newsSoftActivitypassword\x3B1\x3BOptix
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toolbar.anwb.nl") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "newsSoftActivity\u{13}password;1;Optix\u{0a}"))))
; /[a-f0-9]{32}=[a-f0-9]{32}/C
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/C\u{0a}")))))
; @"^\d[a-zA-Z0-9]+$"
(assert (str.in_re X (re.++ (str.to_re "@\u{22}") (re.range "0" "9") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{22}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
