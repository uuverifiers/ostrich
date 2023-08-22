(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}pmd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pmd/i\u{0a}"))))
; /filename=[^\n]*\u{2e}bak/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".bak/i\u{0a}")))))
; /^SpyBuddy\s+Alert/smi
(assert (not (str.in_re X (re.++ (str.to_re "/SpyBuddy") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Alert/smi\u{0a}")))))
; ^([0-9A-Za-z@.]{1,255})$
(assert (str.in_re X (re.++ ((_ re.loop 1 255) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "@") (str.to_re "."))) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
