(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\+)?(\()?(\d+){1,4}(\))?(\s)?(-)?(\d+){1,3}(\s)?(-)?(\d+){1,4}(\s)?(-)?(\d+){1,4}(\s)?(-)?(\d+){1,4}
(assert (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re "(")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.+ (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /^\x2Fcap\x2Ftemp\x2F[A-Za-z0-9]+\x2Ejpg/miU
(assert (str.in_re X (re.++ (str.to_re "//cap/temp/") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jpg/miU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
