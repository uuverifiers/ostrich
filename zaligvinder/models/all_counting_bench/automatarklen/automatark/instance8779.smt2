(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]([a-zA-Z[._][\d]])*[@][a-zA-Z[.][\d]]*[.][a-z[.][\d]]*
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "[") (str.to_re ".") (str.to_re "_")) (re.range "0" "9") (str.to_re "]"))) (str.to_re "@") (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "[") (str.to_re ".")) (re.range "0" "9") (re.* (str.to_re "]")) (str.to_re ".") (re.union (re.range "a" "z") (str.to_re "[") (str.to_re ".")) (re.range "0" "9") (re.* (str.to_re "]")) (str.to_re "\u{0a}")))))
; ^100$|^\s*(\d{0,2})((\.|\,)(\d*))?\s*\%?\s*$
(assert (not (str.in_re X (re.union (str.to_re "100") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) (re.* (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "%")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))))
; User-Agent\x3A\d+Desktop\sIDENTIFY666User-Agent\x3A\x5BStatic
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "Desktop") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "IDENTIFY666User-Agent:[Static\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
