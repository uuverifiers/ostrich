(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}apk/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".apk/i\u{0a}")))))
; \d{2}\s?[A-Z]{1,3}\s?\d{2,4}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 3) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (^\d{5}$)|(^\d{5}-\d{4}$)
(assert (not (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
