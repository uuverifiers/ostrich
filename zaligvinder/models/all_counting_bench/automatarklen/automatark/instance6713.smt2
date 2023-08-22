(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{5})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{4})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{3})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{2})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{1})
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d"))) (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 4 4) (str.to_re "d"))) (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d"))) (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 2 2) (str.to_re "d"))) (re.++ (str.to_re "\u{0a}\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d"))))))
; /^\/[0-9]{5}\.jar$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re ".jar/U\u{0a}"))))
; /filename=[^\n]*\u{2e}xbm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xbm/i\u{0a}")))))
; &[a-zA-Z]+\d{0,3};
(assert (not (str.in_re X (re.++ (str.to_re "&") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re ";\u{0a}")))))
; ^[{|\(]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[\)|}]?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "{") (str.to_re "|") (str.to_re "("))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")))) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (re.union (str.to_re ")") (str.to_re "|") (str.to_re "}"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
