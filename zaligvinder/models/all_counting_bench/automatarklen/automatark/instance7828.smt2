(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{0,5}|[0-9]{0,5}\.[0-9]{0,3})$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 0 5) (re.range "0" "9")) (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}jpeg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpeg/i\u{0a}")))))
; (\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{5})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{4})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{3})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{2})|(\\d{1}-\\d{2}\\s*)(of +)(\\s?\\d{1})
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d"))) (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 4 4) (str.to_re "d"))) (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d"))) (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 2 2) (str.to_re "d"))) (re.++ (str.to_re "\u{0a}\u{5c}") ((_ re.loop 1 1) (str.to_re "d")) (str.to_re "-\u{5c}") ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\u{5c}") (re.* (str.to_re "s")) (str.to_re "of") (re.+ (str.to_re " ")) (str.to_re "\u{5c}") (re.opt (str.to_re "s")) (str.to_re "\u{5c}") ((_ re.loop 1 1) (str.to_re "d"))))))
; /\u{2e}xlsx([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.xlsx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^\+[0-9]{1,3}\([0-9]{3}\)[0-9]{7}$
(assert (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
