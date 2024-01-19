(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(http(s)?\:\/\/\S+)\s
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}http") (re.opt (str.to_re "s")) (str.to_re "://") (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))))
; ^[0-9]{4}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
