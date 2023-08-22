(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Host:\s*?[a-f0-9]{63,64}\./Him
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 63 64) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "./Him\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
