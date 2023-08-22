(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (INSERT INTO\s+)(\w+)(\s+\()([\w+,?\s*]+)(\)\s+VALUES\s+)((\(['?\w+'?,?\s*]+\)\,?;?\s*)+)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re "+") (str.to_re ",") (str.to_re "?") (str.to_re "*") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.++ (str.to_re "(") (re.+ (re.union (str.to_re "'") (str.to_re "?") (str.to_re "+") (str.to_re ",") (str.to_re "*") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ")") (re.opt (str.to_re ",")) (re.opt (str.to_re ";")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "\u{0a}INSERT INTO") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "()") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "VALUES") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
; ^[^\*]{0,}[\*]{0,1}[^\*]{0,}$
(assert (not (str.in_re X (re.++ (re.* (re.comp (str.to_re "*"))) (re.opt (str.to_re "*")) (re.* (re.comp (str.to_re "*"))) (str.to_re "\u{0a}")))))
; (DK-?)?([0-9]{2}\ ?){3}[0-9]{2}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "DK") (re.opt (str.to_re "-")))) ((_ re.loop 3 3) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
