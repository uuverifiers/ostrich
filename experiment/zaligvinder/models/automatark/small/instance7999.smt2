(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}vsd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vsd/i\u{0a}"))))
; <[a-zA-Z]+(\s+[a-zA-Z]+\s*=\s*("([^"]*)"|'([^']*)'))*\s*/>
(assert (str.in_re X (re.++ (str.to_re "<") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}")) (re.++ (str.to_re "'") (re.* (re.comp (str.to_re "'"))) (str.to_re "'"))))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/>\u{0a}"))))
; ^(\d?)*\.?(\d{1}|\d{2})?$
(assert (str.in_re X (re.++ (re.* (re.opt (re.range "0" "9"))) (re.opt (str.to_re ".")) (re.opt (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ';([dmstrl])([ .,?!\)\\/<])
(assert (not (str.in_re X (re.++ (str.to_re "';") (re.union (str.to_re "d") (str.to_re "m") (str.to_re "s") (str.to_re "t") (str.to_re "r") (str.to_re "l")) (re.union (str.to_re " ") (str.to_re ".") (str.to_re ",") (str.to_re "?") (str.to_re "!") (str.to_re ")") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "<")) (str.to_re "\u{0a}")))))
(check-sat)
