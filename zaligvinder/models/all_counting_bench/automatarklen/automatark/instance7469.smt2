(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /<\s*col[^>]*width\s*=\s*[\u{22}\u{27}]?\d{7}/i
(assert (not (str.in_re X (re.++ (str.to_re "/<") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "col") (re.* (re.comp (str.to_re ">"))) (str.to_re "width") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
