(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}psd/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".psd/i\u{0a}")))))
; ^[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (@\s*".*?")|("([^"\\]|\\.)*?")
(assert (not (str.in_re X (re.union (re.++ (str.to_re "@") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{0a}\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (str.to_re "\u{22}"))))))
(assert (> (str.len X) 10))
(check-sat)
